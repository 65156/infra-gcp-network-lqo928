terraform {
  backend "gcs" {
    bucket = "ofx-infrastructure-tf-bkt"
    prefix = ""
  }
}