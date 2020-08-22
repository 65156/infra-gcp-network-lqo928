
module "log_export_project" {
  source              = "../base-project-template"
  project_id          = var.project_id
  project_name        = var.project_name
  org_id              = var.org_id
  folder_id           = var.folder_id
  billing_account_id  = var.billing_account_id
  auto_create_network = var.auto_create_network

  project_labels = var.project_labels

  # Network settings host project,network and subnets must exists before hand
  host_project_id             = var.host_project_id
  shared_vpc_network_name     = var.shared_vpc_network_name
  shared_vpc_subnetwork_names = var.shared_vpc_subnetwork_names


}


resource "google_resource_manager_lien" "aggregate_log_export_lien" {
  parent       = "projects/${module.log_export_project.created_project_id}"
  restrictions = ["resourcemanager.projects.delete"]
  origin       = "prevent-accidental-deletion"
  reason       = "Prevent accidental deletion of exported aggregate logs."

}

resource "google_compute_network" "network" {
  name    = "network"
  project = module.log_export_project.created_project_id

}

module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = module.destination.destination_uri
  log_sink_name          = "${module.log_export_project.created_project_id}-logsink"
  parent_resource_id     = var.org_id
  parent_resource_type   = "organization"
  unique_writer_identity = true
  include_children       = true
}

# Creates Destination bucket for logs 
module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  project_id               = module.log_export_project.created_project_id
  storage_bucket_name      = "${module.log_export_project.created_project_id}-log-export-archive"
  log_sink_writer_identity = module.log_export.writer_identity
  storage_class            = "ARCHIVE"
  location                 = "US"
}

