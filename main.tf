# Set organisational wide policies 

locals {
  org_id                   = "590092815251"
  org_domain               = "ofx.com"
  default_billing_account  = "01B3C9-539FEB-11B3F1"
  default_resource_region  = "australia-southeast1"
  default_resource_zone    = "australia-southeast1-b"
  infrastructure_folder_id = "864576503732"
  auditing_folder_id       = "864576503732"
}
# Configure networks
module "prod_network" {
  source             = ".//modules/shared-vpc"
  project_base_id    = "barbados-prod-583929"
  project_base_name  = "infrastructure-production"
  project_billing_id = local.default_billing_account
  org_id             = local.org_id
  folder_id          = local.infrastructure_folder_id

  project_labels = {
    application_name = "network"
    environment      = "prod"
    team             = "ice"
  }

  # Ensure that count of subnet names, CIDR ranges and regions are the same.
  # The shared-vpc module will loop through the subnet names and pick up 
  # CIDR ranges and region that corresponds to the same index as the subnet name.
  subnet_names    = var.subnet_names
  subnetwork_name = "production-vpc"

  subnet_cidr                     = var.subnet_cidr_prod
  subnet_region                   = var.subnet_region
  subnet_private_ip_google_access = true
  subnet_enable_flow_logs         = true
  # asn                             = 

  private_dns_zones             = "private.prd.gcp.ofx.com."
  private_dns_zone_names        = "private"
  private_dns_zone_descriptions = "private dns zone."

  public_dns_zones             = "prd.gcp.ofx.com."
  public_dns_zone_names        = "public"
  public_dns_zone_descriptions = "public dns zone."

  private_a_records = [

  ]
}

module "dev_network" {
  source             = ".//modules/shared-vpc"
  project_base_id    = "barbados-dev-583929"
  project_billing_id = local.default_billing_account
  project_base_name  = "infrastructure-development"
  org_id             = local.org_id
  folder_id          = local.infrastructure_folder_id

  project_labels = {
    application_name = "network"
    environment      = "dev"
    team             = "ice"
  }

  # Ensure that count of subnet names, CIDR ranges and regions are the same.
  # The shared-vpc module will loop through the subnet names and pick up 
  # CIDR ranges and region that corresponds to the same index as the subnet name.
  subnet_names    = var.subnet_names
  subnetwork_name = "development-vpc"

  subnet_cidr                     = var.subnet_cidr_dev
  subnet_region                   = var.subnet_region
  subnet_private_ip_google_access = true
  subnet_enable_flow_logs         = true
  # asn                             = 

  private_dns_zones             = "private.dev.gcp.ofx.com."
  private_dns_zone_names        = "private"
  private_dns_zone_descriptions = "private dns zone."

  public_dns_zones             = "dev.gcp.ofx.com."
  public_dns_zone_names        = "public"
  public_dns_zone_descriptions = "public dns zone."

  private_a_records = [

  ]
}

module "stage_network" {
  source             = ".//modules/shared-vpc"
  project_base_id    = "barbados-stage-583929"
  project_billing_id = local.default_billing_account
  project_base_name  = "infrastructure-staging"
  org_id             = local.org_id
  folder_id          = local.infrastructure_folder_id
  environment        = "stage"

  project_labels = {
    application_name = "network"
    environment      = "stage"
    team             = "ice"
  }

  # Ensure that count of subnet names, CIDR ranges and regions are the same.
  # The shared-vpc module will loop through the subnet names and pick up 
  # CIDR ranges and region that corresponds to the same index as the subnet name.
  subnet_names                    = var.subnet_names
  subnetwork_name                 = "staging-vpc"
  subnet_cidr                     = var.subnet_cidr_stage
  subnet_region                   = var.subnet_region
  subnet_private_ip_google_access = true
  subnet_enable_flow_logs         = true
  # asn                             = 

  private_dns_zones             = "private.stg.gcp.ofx.com."
  private_dns_zone_names        = "private"
  private_dns_zone_descriptions = "private dns zone."

  public_dns_zones             = "stg.gcp.ofx.com."
  public_dns_zone_names        = "public"
  public_dns_zone_descriptions = "public dns zone."

  private_a_records = [

  ]
}

module "management_network" {
  source             = ".//modules/shared-vpc"
  project_base_id    = "barbados-mgmt-583929"
  project_billing_id = local.default_billing_account
  project_base_name  = "infrastructure-management"
  org_id             = local.org_id
  folder_id          = local.infrastructure_folder_id

  project_labels = {
    application_name = "network"
    environment      = "management"
    team             = "ice"
  }

  # Ensure that count of subnet names, CIDR ranges and regions are the same.
  # The shared-vpc module will loop through the subnet names and pick up 
  # CIDR ranges and region that corresponds to the same index as the subnet name.
  subnet_names                    = var.subnet_names
  subnetwork_name                 = "management-vpc"
  subnet_cidr                     = var.subnet_cidr_mgmt
  subnet_region                   = var.subnet_region
  subnet_private_ip_google_access = true
  subnet_enable_flow_logs         = true
  # asn                             = 

  private_dns_zones             = "private.mgt.gcp.ofx.com."
  private_dns_zone_names        = "private"
  private_dns_zone_descriptions = "private dns zone."

  ignore_public                = "true" # if true will NOT deploy a public zone.
  public_dns_zones             = "mgt.gcp.ofx.com."
  public_dns_zone_names        = "public"
  public_dns_zone_descriptions = "public dns zone."

  private_a_records = [

  ]
}

# Create Service Accounts for Logging and Deployment

# Define roles
locals {
  roles_deployment = [
    "roles/Owner",
    "roles/compute.networkAdmin",
    "roles/compute.admin",
    "roles/iam.securityAdmin",
    "roles/iam.organizationRoleAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/bigquery.admin",
    "roles/storage.admin",
    "roles/resourcemanager.organizationAdmin",
    "roles/resourcemanager.projectIamAdmin",
  ]

  roles_logging = [
    "roles/compute.networkUser",
  ]
}

# Create service account to be used for log exports
resource "google_service_account" "service_account_01" {
  account_id   = "sa-org-logging"
  display_name = "Service Account used for log exports"
  project = module.management_network.created_project_id
}

# Create service account used for org management
resource "google_service_account" "service_account_02" {
  account_id   = "sa-org-deploy"
  display_name = "Service Account used to deploy terraform code."
  project = module.management_network.created_project_id
}

# Create bucket for terraform deployment
resource "google_storage_bucket" "bucket" {
  name          = "statefiles-tf-xjdfh3"
  location      = "US"
  project = module.management_network.created_project_id

    versioning {
      enable = "true"
    }

}
 

# Create VPC peering between shared services network and non prod network
resource "google_compute_network_peering" "management_dev_peering" {
  name         = "peering-management-to-dev"
  network      = module.management_network.vpc_network
  peer_network = module.dev_network.vpc_network

}

resource "google_compute_network_peering" "dev_management_peering" {
  name         = "peering-dev-to-management"
  network      = module.dev_network.vpc_network
  peer_network = module.management_network.vpc_network
  depends_on   = [google_compute_network_peering.dev_management_peering]
}

resource "google_compute_network_peering" "management_stage_peering" {
  name         = "peering-management-to-stage"
  network      = module.management_network.vpc_network
  peer_network = module.stage_network.vpc_network
}

resource "google_compute_network_peering" "stage_management_peering" {
  name         = "peering-stage-to-management"
  network      = module.stage_network.vpc_network
  peer_network = module.management_network.vpc_network
  depends_on   = [google_compute_network_peering.dev_management_peering]
}

# Create VPC peering between shared service VPC and prod network.
resource "google_compute_network_peering" "management_prod_peering" {
  name         = "peering-management-to-prod"
  network      = module.management_network.vpc_network
  peer_network = module.prod_network.vpc_network
}

resource "google_compute_network_peering" "prod_management_peering" {
  name         = "peering-prod-to-management"
  network      = module.prod_network.vpc_network
  peer_network = module.management_network.vpc_network
  depends_on   = [google_compute_network_peering.management_prod_peering]
}

module "aggregate-log-export" {
  source              = ".//modules/aggregate-log-export"
  project_id          = "washington-mgmt-456435"
  project_name        = "logging-collector"
  org_id              = local.org_id
  folder_id           = local.auditing_folder_id
  billing_account_id  = local.default_billing_account
  auto_create_network = false

  project_labels = {
    application_name = "aggregate_log_export"
    environment      = "management"
    team             = "security"
  }

  # Network settings host project,network and subnets must exists before hand
  host_project_id             = ""
  shared_vpc_network_name     = ""
  shared_vpc_subnetwork_names = []

  bucket_location = "US"
  admin_user      = "superadmin@ofx.com"
  service_account = "gcp-ofx-adminlog-exporter-sa@ofx-infrastructure.iam.gserviceaccount.com"


}

# Allow Nagios, SSH, ICMP and HTTPS traffic from on-premise management servers
# resource "google_compute_firewall" "firewall_prod_ingress_allow_management_traffic" {
#   name      = "${var.org_prefix}-vpchost-prod-allowinmgt-fwr"
#   network   = "${module.prod_network.vpc_network}"
#   project   = "${module.prod_network.project_id}"
#   direction = "INGRESS"
#   priority  = 1000

#   allow {
#     protocol = "tcp"
#     ports    = ["5666", "12480"]
#   }

#   allow {
#     protocol = "icmp"
#   }

#   source_ranges = ["10.2.10.243/32", "10.4.8.93/32"]
# }


# Configure billing exports
# SKIP: Managed manually as outlined 
# https://docs.google.com/document/d/1HTWtBcT3LxBPI6-V5KdxpxL-7LTPYKIq8hYueZizsW4/edit#heading=h.5h1o9vv3m6bu. 

# Configure log exports
# module "aggregate_log_export" {
#   source             = "../../shared/log-export"
#   project_base_id    = "logexport-prod"
#   project_billing_id = "${var.default_billing_account}"
#   org_prefix         = "${var.org_prefix}"
#   org_id             = "${var.org_id}"
#   project_labels     = ["${var.aggregate_logs_export_project_labels}"]
#   storage_location   = "${var.aggregate_logs_export_storage_location}"
#   sink_names         = ["${var.aggregate_logs_export_sink_names}"]
#   filters            = ["${var.aggregate_logs_export_filters}"]
# }
