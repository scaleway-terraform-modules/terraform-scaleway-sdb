terraform {
  required_version = ">= 0.13"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = ">= 2.43.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.12.0"
    }
  }
}
