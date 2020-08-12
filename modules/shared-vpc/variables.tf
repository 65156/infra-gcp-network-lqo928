variable "environment" {
  type        = string
  default     = ""
}

variable "dns_zone" {
  type = map
  default =  {
    dev = "dev.gcp.ofx.com"
    stage = "stg.gcp.ofx.com"
    prod = "prd.gcp.ofx.com"
    management = "mgt.gcp.ofx.com"
  }
}

variable "org_prefix" {
  type        = string
  description = "Resource identifier prefix."
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

variable "asn" {
  type        = string
  description = "ASN for Cloud Router"
  default     = ""
}

variable "private_dns_zones" {
  type        = list
  description = "FQDN of private DNS zones."
  default     = []
}

variable "private_dns_zone_names" {
  type        = list
  description = "Names of private DNS zones."
  default     = []
}

variable "private_dns_zone_descriptions" {
  type        = list
  description = "Descriptions of private DNS zones."
  default     = []
}

variable "private_a_records" {
  type        = list
  description = "Comma separated list of key value pair private A records."
  default     = []
}

variable "public_dns_zones" {
  type        = list
  description = "FQDN of private DNS zones."
  default     = []
}

variable "public_dns_zone_names" {
  type        = list
  description = "Names of private DNS zones."
  default     = []
}

variable "public_dns_zone_descriptions" {
  type        = list
  description = "Descriptions of private DNS zones."
  default     = []
}

variable "public_a_records" {
  type        = list
  description = "Comma separated list of key value pair private A records."
  default     = []
}

variable "inbound_dns_forwarding_policy_name" {
  type        = string
  description = "Name of inbound DNS policy."
  default     = ""
}

variable "inbound_dns_forwarding_policy_desc" {
  type        = string
  description = "Description of inbound DNS policy."
  default     = ""
}

variable "org_id" {}

variable "folder_id" {}