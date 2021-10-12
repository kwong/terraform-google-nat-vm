/**
 * # terraform-google-nat-vm
 *
 * This repository contains a terraform module that allows you to deploy a NAT hosted on GCP's compute instances as backend to a TCP proxy load balancer
 *
 */

resource "random_id" "suffix" {
  byte_length = 2
}

/*********************
 * Forwarding rule
 ********************/

resource "google_compute_forwarding_rule" "nat_lb_forwarding_rule" {
  project               = var.project
  name                  = format("%s-%s", "nat-lb-forwarding-rule", random_id.suffix.hex)
  backend_service       = google_compute_region_backend_service.default.id
  provider              = google-beta
  region                = var.region
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  all_ports             = true
  allow_global_access   = true
  network               = var.network
  subnetwork            = var.subnetwork

}

/********************
 * Backend Service
 ********************/

resource "google_compute_region_backend_service" "default" {
  project               = var.project
  name                  = format("%s-%s", "nat-lb-backend-service", random_id.suffix.hex)
  provider              = google-beta
  region                = var.region
  protocol              = "TCP"
  load_balancing_scheme = "INTERNAL"
  health_checks         = [google_compute_region_health_check.default.id]
  backend {
    group          = google_compute_region_instance_group_manager.mig.instance_group
    balancing_mode = "CONNECTION"
  }
}

/*************************
 * Instance template
 ************************/

resource "google_compute_instance_template" "instance_template" {
  project        = var.project
  name           = format("%s-%s", "nat-lb-mig-template", random_id.suffix.hex)
  description    = "template for creating NAT instances"
  provider       = google-beta
  machine_type   = var.machine_type
  tags           = ["nat"]
  can_ip_forward = true

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
  }

  disk {
    source_image = "debian-cloud/debian-10"
    auto_delete  = true
    boot         = true
  }

  metadata = {
    startup-script = <<-EOF
      #! /bin/bash
      sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
      sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
      EOF
  }

  lifecycle {
    create_before_destroy = true
  }
}

/****************
 * Health check
 ****************/
resource "google_compute_region_health_check" "default" {
  project  = var.project
  name     = format("%s-%s", "nat-lb-hc", random_id.suffix.hex)
  provider = google-beta
  region   = var.region

  tcp_health_check {
    port = "22"
  }
}

/*********
 * MIG
 ********/

resource "google_compute_region_instance_group_manager" "mig" {
  project  = var.project
  name     = format("%s-%s", "nat-lb-mig", random_id.suffix.hex)
  provider = google-beta
  region   = var.region
  version {
    instance_template = google_compute_instance_template.instance_template.id
    name              = "primary"
  }
  base_instance_name = "nat-lb-mig"
  target_size        = 2
}
