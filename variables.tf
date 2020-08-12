variable "global" {
  type = "map"
  default = {
    "org_id"                  = "590092815251"
    "org_domain"              = "ofx.com"
    "default_billing_account" = "01B3C9-539FEB-11B3F1"
    "default_resource_region" = "australia-southeast1"
    "default_resource_zone"   = "australia-southeast1-b"
  }
}


variable "project_base_id" {
  type        = "string"
  description = "Project name to be prefixed by organisation short name and postfixed by resource type."
}

variable "project_billing_id" {
  type        = "string"
  description = "Billing account associated to the billing export project."
}

variable "project_labels" {
  type        = "map"
  description = "Labels for the billing export project."
}

variable "subnet_names" {
  type        = "list"
  description = "List of subnet names"
  default     = ["private01", "public01"]
}

variable "subnet_cidr" {
  type        = "list"
  description = "List of subnet CIDR"
  default     = []
}  

variable "subnet_region" {
  type        = "list"
  description = "List of subnet regions"
  default     = ["australia-southeast1", "australia-southeast1"]
}

variable "subnet_private_ip_google_access" {
  default = true
}

variable "subnet_enable_flow_logs" {
  default = true
}

variable "allow_ingress_tcp_source_ranges" {
  type        = "map"
  description = "Map of source ranges by TCP port number"
  default     = {}
}

variable "allow_ingress_icmp_source_ranges" {
  type        = "list"
  description = "List of source CIDR ranges to allow ICMP traffic from"
  default     = []
}

variable "asn" {
  type        = "string"
  description = "ASN for Cloud Router"
  default     = ""
}

variable "private_dns_zones" {
  type        = "list"
  description = "FQDN of private DNS zones."
  default     = []
}

variable "private_dns_zone_names" {
  type        = "list"
  description = "Names of private DNS zones."
  default     = []
}

variable "private_dns_zone_descriptions" {
  type        = "list"
  description = "Descriptions of private DNS zones."
  default     = []
}

variable "private_a_records" {
  type        = "list"
  description = "Comma separated list of key value pair private A records."
  default     = []
}

variable "inbound_dns_forwarding_policy_name" {
  type        = "string"
  description = "Name of inbound DNS policy."
  default     = ""
}

variable "inbound_dns_forwarding_policy_desc" {
  type        = "string"
  description = "Description of inbound DNS policy."
  default     = ""
}

variable "org_id" {}

variable "folder_id" {}