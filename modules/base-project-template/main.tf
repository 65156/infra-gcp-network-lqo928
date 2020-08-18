# Create basic project
resource "google_project" "service_project" {
  name                = var.project_name
  project_id          = var.project_id
  billing_account     = var.billing_account_id
  folder_id           = var.folder_id
  auto_create_network = false
  labels              = var.project_labels
}

# Enable Google IAM API
resource "google_project_service" "enable_iam_api" {
  depends_on = [google_project.service_project]
  project    = var.project_id
  service    = "iam.googleapis.com"
}

# Enable service usage API
resource "google_project_service" "enable_serviceusage_apis" {
  depends_on = [google_project.service_project]
  project    = var.project_id
  service    = "serviceusage.googleapis.com"
}

#Enable Resource Manager API
resource "google_project_service" "enable_rm_api" {
  depends_on = [google_project.service_project]
  project    = var.project_id
  service    = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "enable_bq_api" {
  depends_on                 = [google_project.service_project]
  project                    = var.project_id
  service                    = "bigquery.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "enable_dataflow_api" {
  depends_on = [google_project.service_project]
  project    = var.project_id
  service    = "dataflow.googleapis.com"
}

#enable pubsub
resource "google_project_service" "enable_pubsub_apis" {
  depends_on = [google_project.service_project]
  project    = var.project_id
  service    = "pubsub.googleapis.com"
}

# Make this project a service project and attach with Host project containing VPC
resource "google_compute_shared_vpc_service_project" "vpc_service_project" {
  count           = length(var.shared_vpc_subnetwork_names) >= 1 ? 1 : 0
  depends_on      = [google_project.service_project]
  host_project    = var.host_project_id
  service_project = google_project.service_project.project_id
}

locals {
  gcp_project_service_account_roles = [
    "roles/compute.networkUser",
  ]
}

# Create project iam binding to allow service project (this project) to use host project for networks and sub-networks.
resource "google_project_iam_member" "compute_networkuser_compute" {
  count      = length(var.shared_vpc_subnetwork_names) >= 1 ? length(local.gcp_project_service_account_roles) : 0
  depends_on = [google_compute_shared_vpc_service_project.vpc_service_project]
  project    = var.host_project_id
  role       = local.gcp_project_service_account_roles[count.index]
  member     = "serviceAccount:service-${google_project.service_project.number}@compute-system.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "compute_networkuser_cloudsvc" {
  count      = length(var.shared_vpc_subnetwork_names) >= 1 ? length(local.gcp_project_service_account_roles) : 0
  depends_on = [google_compute_shared_vpc_service_project.vpc_service_project]
  project    = var.host_project_id
  role       = local.gcp_project_service_account_roles[count.index]
  member     = "serviceAccount:${google_project.service_project.number}@cloudservices.gserviceaccount.com"
}

locals {
  gcp_subnet_service_account_roles = [
    "roles/compute.networkUser",
  ]
}

#Create subnetwork IAM binding to allow service project to use subnetwork in host project.
resource "google_compute_subnetwork_iam_member" "compute_subnetworkuser_compute_sa" {
  count      = length(var.shared_vpc_subnetwork_names) >= 1 ? length(var.shared_vpc_subnetwork_names) : 0
  provider   = google-beta
  depends_on = [google_compute_shared_vpc_service_project.vpc_service_project]
  project    = var.host_project_id
  role       = "roles/compute.networkUser"
  subnetwork = var.shared_vpc_subnetwork_names[count.index]
  member     = "serviceAccount:service-${google_project.service_project.number}@compute-system.iam.gserviceaccount.com"
}

resource "google_compute_subnetwork_iam_member" "compute_subnetworkuser_cloudsvc_sa" {
  count      = length(var.shared_vpc_subnetwork_names) >= 1 ? length(var.shared_vpc_subnetwork_names) : 0
  provider   = google-beta
  depends_on = [google_compute_shared_vpc_service_project.vpc_service_project]
  project    = var.host_project_id
  role       = "roles/compute.networkUser"
  subnetwork = var.shared_vpc_subnetwork_names[count.index]
  member     = "serviceAccount:${google_project.service_project.number}@cloudservices.gserviceaccount.com"
}

resource "google_compute_subnetwork_iam_member" "compute_subnetworkuser_dataflow_sa" {
  count      = length(var.shared_vpc_subnetwork_names) >= 1 ? length(var.shared_vpc_subnetwork_names) : 0
  provider   = google-beta
  depends_on = [google_compute_shared_vpc_service_project.vpc_service_project]
  project    = var.host_project_id
  role       = "roles/compute.networkUser"
  subnetwork = var.shared_vpc_subnetwork_names[count.index]
  member     = "serviceAccount:service-${google_project.service_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com"
}
