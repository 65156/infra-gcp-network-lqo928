variable "project_id" {}

variable "project_name" {}
variable "billing_account_id" {}
variable "org_id" {}

variable "folder_id" {}

variable "project_labels" {
  type = map
}

# variable "folder_id"{}
variable "auto_create_network" { default = false }

# Project Id for host project 
variable "host_project_id" {}

#Name of shared VPC network in host project
variable "shared_vpc_network_name" {}

#Name of subnetwork in shared VPC network reserved for this service project

variable "shared_vpc_subnetwork_names" {
  type        = map()
  description = "List of subnet names"
  default     = {}
}

variable "region" {
  default = "australia-southeast1"
}

variable "bucket_region" {
  default = "ASIA"
}