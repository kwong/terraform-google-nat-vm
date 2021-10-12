[//]: # (BEGIN_TF_DOCS)

# terraform-google-nat-vm

This repository contains a terraform module that allows you to deploy a NAT hosted on GCP's compute instances as backend to a TCP proxy load balancer

## Requirements

| Name | Version |
|------|---------|
| terraform | >=1.0.8 |
| google | >= 3.87.0 |
| google-beta | >= 3.87.0 |

## Providers

| Name | Version |
|------|---------|
| google-beta | >= 3.87.0 |
| random | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_firewall.fw-iap](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_compute_firewall) | resource |
| [google-beta_google_compute_forwarding_rule.nat_lb_forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_compute_forwarding_rule) | resource |
| [google-beta_google_compute_instance_template.instance_template](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_compute_instance_template) | resource |
| [google-beta_google_compute_region_backend_service.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_compute_region_backend_service) | resource |
| [google-beta_google_compute_region_health_check.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_compute_region_health_check) | resource |
| [google-beta_google_compute_region_instance_group_manager.mig](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_compute_region_instance_group_manager) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| machine\_type | n/a | `string` | `"e2-small"` | no |
| network | n/a | `any` | n/a | yes |
| project | n/a | `any` | n/a | yes |
| region | n/a | `string` | `"asia-southeast1"` | no |
| subnetwork | n/a | `any` | n/a | yes |

## Outputs

No outputs.

[//]: # (END_TF_DOCS)