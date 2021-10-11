terraform {
  required_version = ">=1.0.8"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.87.0"
    }

    google-beta = {
      source  = "hashicorp/google"
      version = ">= 3.87.0"
    }
  }
}
