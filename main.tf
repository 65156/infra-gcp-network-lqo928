# Set organisational wide policies 

locals {
  org_id                   = "590092815251"
  org_domain               = "ofx.com"
  default_billing_account  = "01B3C9-539FEB-11B3F1"
  default_resource_region  = "australia-southeast1"
  default_resource_zone    = "australia-southeast1-b"
  infrastructure_folder_id = "864576503732"
  auditing_folder_id       = "864576503732"

  management_apis = [ # leveraged by service account in management project to deploy services
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "accesscontextmanager.googleapis.com",
  ]
}
# Configure networks
module "dev_network" {
  source             = ".//modules/shared-vpc"
  project_base_id    = "barbados-dev-583929"
  project_billing_id = local.default_billing_account
  project_base_name  = "Shared VPC - Development"
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
  subnet_service_networking       = "10.32.24.0/24"
  subnet_serverless               = "10.32.31.0/28"

  subnet_private_ip_google_access = true
  subnet_enable_flow_logs         = true
  
}

module "stage_network" {
  source             = ".//modules/shared-vpc"
  project_base_id    = "barbados-stage-583929"
  project_billing_id = local.default_billing_account
  project_base_name  = "Shared VPC - Staging"
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
  subnet_service_networking       = "10.40.24.0/24"
  subnet_serverless               = "10.40.31.0/28"
  subnet_private_ip_google_access = true
  subnet_enable_flow_logs         = true

}

module "prod_network" {
  source             = ".//modules/shared-vpc"
  project_base_id    = "barbados-prod-583929"
  project_base_name  = "Shared VPC - Production"
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
  subnet_service_networking       = "10.48.24.0/24"
  subnet_serverless               = "10.48.31.0/28"
  subnet_private_ip_google_access = true
  subnet_enable_flow_logs         = true

}

module "management_network" {
  source             = ".//modules/shared-vpc"
  project_base_id    = "barbados-mgmt-583929"
  project_billing_id = local.default_billing_account
  project_base_name  = "Shared VPC - Management"
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

  is_management                   = true
}

#cloud Resource manager API enable 
resource "google_project_service" "management_apis" {
  count   = length(local.management_apis)
  project = "barbados-mgmt-583929"
  service = local.management_apis[count.index]
}

# Create bucket for terraform deployment
resource "google_storage_bucket" "bucket" {
  name     = "terraform-statefiles-xjdfh3"
  location = "US"
  project  = module.management_network.project_id

  versioning {
    enabled = "true"
  }

}

# Create VPC peering between shared services network and non prod network
resource "google_compute_network_peering" "management_dev_peering" {
  name         = "management-to-dev"
  network      = module.management_network.vpc_network
  peer_network = module.dev_network.vpc_network

}

resource "google_compute_network_peering" "dev_management_peering" {
  name         = "dev-to-management"
  network      = module.dev_network.vpc_network
  peer_network = module.management_network.vpc_network
  depends_on   = [google_compute_network_peering.dev_management_peering]
}

resource "google_compute_network_peering" "management_stage_peering" {
  name         = "management-to-stage"
  network      = module.management_network.vpc_network
  peer_network = module.stage_network.vpc_network
}

resource "google_compute_network_peering" "stage_management_peering" {
  name         = "stage-to-management"
  network      = module.stage_network.vpc_network
  peer_network = module.management_network.vpc_network
  depends_on   = [google_compute_network_peering.dev_management_peering]
}

# Create VPC peering between shared service VPC and prod network.
resource "google_compute_network_peering" "management_prod_peering" {
  name         = "management-to-prod"
  network      = module.management_network.vpc_network
  peer_network = module.prod_network.vpc_network
}

resource "google_compute_network_peering" "prod_management_peering" {
  name         = "prod-to-management"
  network      = module.prod_network.vpc_network
  peer_network = module.management_network.vpc_network
  depends_on   = [google_compute_network_peering.management_prod_peering]
}

