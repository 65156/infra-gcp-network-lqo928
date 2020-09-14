provider "google" {
  region = var.global["default_resource_region"]
}

provider "google-beta" {
  region = var.global["default_resource_region"]
}

terraform {
  backend "gcs" {
    bucket = "statefiles-tf-xjdfh2"
    prefix = "gcp/network"
  }
}



