variable "environment" {
  type    = string
  default = ""
}

variable "dns_zone" {
  type = map
  default = {
    dev        = "dev.gcp.ofx.com"
    stage      = "stg.gcp.ofx.com"
    prod       = "prd.gcp.ofx.com"
    management = "mgt.gcp.ofx.com"
  }
}

variable "project_base_name" {
  type        = string
  description = "Project name to be prefixed by organisation short name and postfixed by resource type."
}

variable "project_base_id" {
  type        = string
  description = "Project name to be prefixed by organisation short name and postfixed by resource type."
}

variable "project_billing_id" {
  type        = string
  description = "Billing account associated to the billing export project."
}

variable "project_labels" {
  type        = map
  description = "Labels for the billing export project."
}

variable "subnetwork_name" {
  type    = string
  default = ""
}

variable "subnet_names" {
  type        = list
  description = "List of subnet names"
  default     = []
}

variable "subnet_cidr" {
  type        = list
  description = "List of subnet CIDR"
  default     = []
}

variable "subnet_region" {
  type        = list
  description = "List of subnet regions"
  default     = []
}

variable "subnet_private_ip_google_access" {
  default = true
}

variable "subnet_enable_flow_logs" {
  default = true
}

variable "allow_ingress_tcp_source_ranges" {
  type        = map
  description = "Map of source ranges by TCP port number"
  default     = {}
}

variable "allow_ingress_icmp_source_ranges" {
  type        = list
  description = "List of source CIDR ranges to allow ICMP traffic from"
  default     = []
}

variable "org_id" {}
variable "folder_id" {}
variable "ignore_public" {
  type    = bool
  default = "false"
}
variable "subnet_service_networking" {
  default = "10.0.0.0/24"
}
variable "subnet_serverless" {
  default = "10.0.0.0/28"
}
variable "is_management" {
  default = false
  }