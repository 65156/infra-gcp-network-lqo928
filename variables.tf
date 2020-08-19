variable "global" {
  type = map
  default = {
    "org_id"                  = "590092815251"
    "org_domain"              = "ofx.com"
    "default_billing_account" = "01B3C9-539FEB-11B3F1"
    "default_resource_region" = "australia-southeast1"
    "default_resource_zone"   = "australia-southeast1-b"
  }
}

variable "subnet_cidr_dev" {
  type        = list
  description = "subnets to provision"
  default     = ["10.32.0.0/21", "10.32.16.0/21"]
}

variable "subnet_cidr_stage" {
  type        = list
  description = "subnets to provision"
  default     = ["10.40.0.0/21", "10.40.16.0/21"]
}
variable "subnet_cidr_prod" {
  type        = list
  description = "subnets to provision"
  default     = ["10.48.0.0/21", "10.48.16.0/21"]
}

variable "subnet_cidr_mgmt" {
  type        = list
  description = "subnets to provision"
  default     = ["10.39.0.0/21", "10.39.16.0/21"]
}

variable "subnet_names" {
  type        = list
  description = "List of subnet names"
  default     = ["private-01", "public-01"]
}

variable "subnet_region" {
  type        = list
  description = "List of subnet regions"
  default     = ["australia-southeast1", "australia-southeast1"]
}

variable "subnet_private_ip_google_access" {
  default = true
}

variable "subnet_enable_flow_logs" {
  default = true
}