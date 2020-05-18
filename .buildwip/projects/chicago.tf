locals {
  codename            = "chicago"
  uuid                = "948412"
  application_name    = "enterprise_data_warehouse"
  team                = "d3"
  folder_id           = google_folder.data.name
  auto_create_network = false
  source_module       = "./modules/base-project-template"
}

module "development" {
  source              = local.source_module
  project_id          = local.codename + "-dev-" + locals.uuid
  folder_id           = local.folder_id
  auto_create_network = local.auto_create_network

  project_labels = {
    application_name = local.application_name
    environment      = "dev"
    team             = local.team
    cicd             = "${var.global["cicd"]}"
    repository       = "${var.global["repository"]}"
  }

  # Network settings host project,network and subnets must exists before hand
  #host_project_id             = "${local.org_prefix}-vpchost-dev"
  #shared_vpc_network_name     = "${local.org_prefix}-vpchost-dev-vpc"
  #shared_vpc_subnetwork_names = ["${local.org_prefix}-vpchost-dev-private01-net-pxn17o", "${local.org_prefix}-vpchost-dev-public01-net-pxn17o"]
}

module "staging" {
  source              = local.source_module
  project_id          = local.codename + "-stage-" + locals.uuid
  folder_id           = local.folder_id
  auto_create_network = local.auto_create_network

  project_labels = {
    application_name = local.application_name
    environment      = "stage"
    team             = local.team
    cicd             = "${var.global["cicd"]}"
    repository       = "${var.global["repository"]}"
  }

  # Network settings host project,network and subnets must exists before hand
  #host_project_id             = "${local.org_prefix}-vpchost-test"
  #shared_vpc_network_name     = "${local.org_prefix}-vpchost-test-vpc"
  #shared_vpc_subnetwork_names = ["${local.org_prefix}-vpchost-test-private01-net-pxn17o", "${local.org_prefix}-vpchost-test-public01-net-pxn17o"]
}

module "production" {
  source              = local.source_module
  project_id          = local.codename + "-prod-" + locals.uuid
  folder_id           = local.folder_id
  auto_create_network = local.auto_create_network

  project_labels = {
    application_name = local.application_name
    environment      = "prod"
    team             = local.team
    cicd             = "${var.global["cicd"]}"
    repository       = "${var.global["repository"]}"
  }

  # Network settings host project,network and subnets must exists before hand
  #host_project_id             = "${local.org_prefix}-vpchost-prod"
  #shared_vpc_network_name     = "${local.org_prefix}-vpchost-ptod-vpc"
  #shared_vpc_subnetwork_names = ["${local.org_prefix}-vpchost-prod-private01-net-pxn17o", "${local.org_prefix}-vpchost-prod-public01-net-pxn17o"]
}