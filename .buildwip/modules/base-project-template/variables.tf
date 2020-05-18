variable "project_id" {}
variable "project_name" {}
variable "billing_account_id" {}
variable "org_id" {}
variable "folder_id" {
  type = "string"
}
variable "project_labels" {
  type = "map"
}
variable "auto_create_network" { default = false } # Project Id for host project 
variable "host_project_id" {}                      # Name of shared VPC network in host project
variable "shared_vpc_network_name" {}
variable "shared_vpc_subnetwork_names" {
  type        = "list"
  description = "List of subnet names"
  default     = []
} # Name of subnetwork in shared VPC network reserved for this service project
variable "region" { default = "australia-southeast1" }