terraform {
  backend "gcs" {
    bucket = "statefiles-tf-xjdfh2"
    prefix = "gcp/network"
  }
}