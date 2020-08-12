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
  source             = "../modules/shared-vpc"
  project_base_id    = "vpc-prod-5mnd19"
  project_billing_id = "${local.default_billing_account}"
  org_id             = "${local.org_id}"
  folder_id          = "${local.infrastructure_folder_id}"

  project_labels = {
    application_name = "network"
    environment      = "prod"
    team             = "ice"
  }

  # Ensure that count of subnet names, CIDR ranges and regions are the same.
  # The shared-vpc module will loop through the subnet names and pick up 
  # CIDR ranges and region that corresponds to the same index as the subnet name.
  subnet_names = var.subnet_names

  subnet_cidr                     = ["10.48.0.0/21", "10.48.16.0/21"]
  subnet_region                   = var.subnet_region
  subnet_private_ip_google_access = true
  subnet_enable_flow_logs         = true
  # asn                             = 

  private_dns_zones             = ["prd.gcp.ofx.com"]
  private_dns_zone_names        = ["private"]
  private_dns_zone_descriptions = ["private dns zone."]

  private_a_records = [

  ]
}

module "dev_network" {
  source             = "../modules/shared-vpc"
  project_base_id    = "vpc-dev-5mnd19"
  project_billing_id = "${local.default_billing_account}"
  org_id             = "${local.org_id}"
  folder_id          = "${local.infrastructure_folder_id}"

  project_labels = {
    application_name = "network"
    environment      = "dev"
    team             = "ice"
  }

  # Ensure that count of subnet names, CIDR ranges and regions are the same.
  # The shared-vpc module will loop through the subnet names and pick up 
  # CIDR ranges and region that corresponds to the same index as the subnet name.
  subnet_names = var.subnet_names

  subnet_cidr                     = ["10.32.0.0/21", "10.32.16.0/21"]
  subnet_region                   = var.subnet_region
  subnet_private_ip_google_access = true
  subnet_enable_flow_logs         = true
  # asn                             = 

  private_dns_zones             = ["dev.gcp.ofx.com"]
  private_dns_zone_names        = ["private"]
  private_dns_zone_descriptions = ["private dns zone."]

  private_a_records = [

  ]
}

module "stage_network" {
  source             = "../modules/shared-vpc"
  project_base_id    = "vpc-stage-5mnd19"
  project_billing_id = "${local.default_billing_account}"
  org_id             = "${local.org_id}"
  folder_id          = "${local.infrastructure_folder_id}"

  project_labels = {
    application_name = "network"
    environment      = "stage"
    team             = "ice"
  }

  # Ensure that count of subnet names, CIDR ranges and regions are the same.
  # The shared-vpc module will loop through the subnet names and pick up 
  # CIDR ranges and region that corresponds to the same index as the subnet name.
  subnet_names = var.subnet_names

  subnet_cidr                     = ["10.40.0.0/21", "10.40.16.0/21"]
  subnet_region                   = var.subnet_region
  subnet_private_ip_google_access = true
  subnet_enable_flow_logs         = true
  # asn                             = 

  private_dns_zone              = ["private.gcp.ofx.com"]
  private_dns_zone_names        = ["private"]
  private_dns_zone_descriptions = ["private dns zone."]

  private_a_records = [

  ]
}

module "management_network" {
  source             = "../modules/shared-vpc"
  project_base_id    = "vpchost-management-5mnd19"
  project_billing_id = "${local.default_billing_account}"
  org_id             = "${local.org_id}"
  folder_id          = "${local.infrastructure_folder_id}"

  project_labels = {
    application_name = "management-host-vpc"
    environment      = "management"
    team             = "ice"
  }

  # Ensure that count of subnet names, CIDR ranges and regions are the same.
  # The shared-vpc module will loop through the subnet names and pick up 
  # CIDR ranges and region that corresponds to the same index as the subnet name.
  subnet_names = var.subnet_names

  subnet_cidr                     = ["10.39.0.0/21", "10.39.16.0/21"]
  subnet_region                   = var.subnet_region
  subnet_private_ip_google_access = true
  subnet_enable_flow_logs         = true
  # asn                             = 

  private_dns_zones             = ["private.gcp.ofx.com"]
  private_dns_zone_names        = ["private"]
  private_dns_zone_descriptions = ["private dns zone."]

  private_a_records = [

  ]
}

# Create VPC peering between shared services network and non prod network
resource "google_compute_network_peering" "management_dev_peering" {
  name         = "peering-management-to-dev-"
  network      = "${module.management_network.vpc_network}"
  peer_network = "${module.dev_network.vpc_network}"

}

resource "google_compute_network_peering" "management_stage_peering" {
  name         = "peering-management-to-stage"
  network      = "${module.management_network.vpc_network}"
  peer_network = "${module.test_network.vpc_network}"
  depends_on   = ["google_compute_network_peering.management_dev_peering"]

}

resource "google_compute_network_peering" "dev_management_peering" {
  name         = "peering-dev-to-management"
  network      = "${module.dev_network.vpc_network}"
  peer_network = "${module.management_network.vpc_network}"

  depends_on = ["google_compute_network_peering.management_test_peering"]
}

resource "google_compute_network_peering" "test_management_peering" {
  name         = "peering-test-to-management"
  network      = "${module.test_network.vpc_network}"
  peer_network = "${module.management_network.vpc_network}"

  depends_on = ["google_compute_network_peering.dev_management_peering"]
}
# Create VPC peering between shared service VPC and prod network.
resource "google_compute_network_peering" "management_prod_peering" {
  name         = "peering-management-to-prod"
  network      = "${module.management_network.vpc_network}"
  peer_network = "${module.prod_network.vpc_network}"
  depends_on   = ["google_compute_network_peering.test_management_peering"]
}

resource "google_compute_network_peering" "prod_management_peering" {
  name         = "peering-prod-to-management"
  network      = "${module.prod_network.vpc_network}"
  peer_network = "${module.management_network.vpc_network}"
  depends_on   = ["google_compute_network_peering.management_prod_peering"]
}

module "aggregate-log-export" {
  source              = "../modules/aggregate-log-export"
  project_id          = "${local.org_prefix}-log-export"
  project_name        = "${local.org_prefix}-log-export"
  org_id              = "${local.org_id}"
  org_prefix          = "${local.org_prefix}"
  folder_id           = "${local.auditing_folder_id}"
  billing_account_id  = "${local.default_billing_account}"
  auto_create_network = false

  project_labels = {
    application_name = "aggregate_log_export"
    environment      = "prod"
    team             = "ice"
  }

  # Network settings host project,network and subnets must exists before hand
  host_project_id             = ""
  shared_vpc_network_name     = ""
  shared_vpc_subnetwork_names = []

  bucket_location = "australia-southeast1"
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