# Create basic project
resource "google_project" "service_project" {
  name            = "${var.project_id}"
  project_id      = "${var.project_id}"
  billing_account = "${var.global["default_billing_account"]}" 
  folder_id       = "${var.folder_id}"
  org_id          = "${var.global["org_id"]}" 
  labels          = "${var.project_labels}"
  auto_create_network = false
}

# Enable Google IAM API
resource "google_project_service" "enable-iam-api" {
  depends_on = ["google_project.service_project"]
  project    = "${var.project_id}"
  service    = "iam.googleapis.com"
}

# Enable service usage API
resource "google_project_service" "enable-serviceusage-apis" {
  depends_on = ["google_project.service_project"]
  project    = "${var.project_id}"
  service    = "serviceusage.googleapis.com"
}

#Enable Resource Manager API
resource "google_project_service" "enable-rm-api" {
  depends_on = ["google_project.service_project"]
  project    = "${var.project_id}"
  service    = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "enable-bq-api" {
  depends_on = ["google_project.service_project"]
  project    = "${var.project_id}"
  service    = "bigquery.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "enable-dataflow-api" {
  depends_on = ["google_project.service_project"]
  project    = "${var.project_id}"
  service    = "dataflow.googleapis.com"
}

# Make this project a service project and attach with Host project containing VPC
resource "google_compute_shared_vpc_service_project" "vpc_service_project" {
  count           = "${length(var.shared_vpc_subnetwork_names) >= 1 ? 1 : 0}"
  depends_on      = ["google_project.service_project"]
  host_project    = "${var.host_project_id}"
  service_project = "${google_project.service_project.project_id}"

  # provisioner "local-exec" {
  #   command = <<EOF
  #     gcloud beta dns managed-zones create ${var.project_id}-default-mz \
  #       --visibility=private \
  #       --description="Activate DNS service for VPC Service Controls" \
  #       --dns-name=. \
  #       --project=${var.project_id} \
  #       --networks=
  #   EOF
  # }
}

locals {
  gcp_project_service_account_roles = [
    "roles/compute.networkUser",
  ]
}

# Create project iam binding to allow service project (this project) to use host project for networks and sub-networks.
resource "google_project_iam_member" "compute-networkuser-compute" {
  count      = "${length(var.shared_vpc_subnetwork_names) >= 1 ? length(local.gcp_project_service_account_roles) : 0}"
  depends_on = ["google_compute_shared_vpc_service_project.vpc_service_project"]
  project    = "${var.host_project_id}"
  role       = "${local.gcp_project_service_account_roles[count.index]}"
  member     = "serviceAccount:service-${google_project.service_project.number}@compute-system.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "compute-networkuser-cloudsvc" {
  count      = "${length(var.shared_vpc_subnetwork_names) >= 1 ? length(local.gcp_project_service_account_roles) : 0}"
  depends_on = ["google_compute_shared_vpc_service_project.vpc_service_project"]
  project    = "${var.host_project_id}"
  role       = "${local.gcp_project_service_account_roles[count.index]}"
  member     = "serviceAccount:${google_project.service_project.number}@cloudservices.gserviceaccount.com"
}

locals {
  gcp_subnet_service_account_roles = [
    "roles/compute.networkUser",
  ]
}

#Create subnetwork IAM binding to allow service project to use subnetwork in host project.
resource "google_compute_subnetwork_iam_member" "compute-subnetworkuser-compute-sa" {
  count      = "${length(var.shared_vpc_subnetwork_names) >= 1 ? length(var.shared_vpc_subnetwork_names) : 0}"
  provider   = "google-beta"
  depends_on = ["google_compute_shared_vpc_service_project.vpc_service_project"]
  project    = "${var.host_project_id}"
  role       = "roles/compute.networkUser"
  subnetwork = "${var.shared_vpc_subnetwork_names[count.index]}"
  member     = "serviceAccount:service-${google_project.service_project.number}@compute-system.iam.gserviceaccount.com"
}

resource "google_compute_subnetwork_iam_member" "compute-subnetworkuser-cloudsvc-sa" {
  count      = "${length(var.shared_vpc_subnetwork_names) >= 1 ? length(var.shared_vpc_subnetwork_names) : 0}"
  provider   = "google-beta"
  depends_on = ["google_compute_shared_vpc_service_project.vpc_service_project"]
  project    = "${var.host_project_id}"
  role       = "roles/compute.networkUser"
  subnetwork = "${var.shared_vpc_subnetwork_names[count.index]}"
  member     = "serviceAccount:${google_project.service_project.number}@cloudservices.gserviceaccount.com"
}

resource "google_compute_subnetwork_iam_member" "compute-subnetworkuser-dataflow-sa" {
  count      = "${length(var.shared_vpc_subnetwork_names) >= 1 ? length(var.shared_vpc_subnetwork_names) : 0}"
  provider   = "google-beta"
  depends_on = ["google_compute_shared_vpc_service_project.vpc_service_project"]
  project    = "${var.host_project_id}"
  role       = "roles/compute.networkUser"
  subnetwork = "${var.shared_vpc_subnetwork_names[count.index]}"
  member     = "serviceAccount:service-${google_project.service_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com"
}