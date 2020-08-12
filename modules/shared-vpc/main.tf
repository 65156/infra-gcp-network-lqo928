# Create host VPC project
locals {


  activate_apis = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "cloudbuild.googleapis.com",
    "logging.googleapis.com",
    "storage-api.googleapis.com",
    "pubsub.googleapis.com",
    "dns.googleapis.com",
    "container.googleapis.com",
    "bigqueryreservation.googleapis.com",
  ]

  # api_set = toset(locals.activate_apis)
}

resource "google_project" "shared_vpc_host_project" {
  name                = "${var.project_base_id}"
  project_id          = "${var.project_base_id}"
  folder_id           = "${var.folder_id}"
  billing_account     = "${var.project_billing_id}"
  labels              = "${var.project_labels}"
  auto_create_network = false
}

# Enable APIs
resource "google_project_service" "shared_vpc_api" {

  count   = "${length(local.activate_apis)}"
  project = "${google_project.shared_vpc_host_project.project_id}"
  service = "${local.activate_apis[count.index]}"
  # disable_on_destroy = true
  disable_dependent_services = true
  # depends_on = ["google_project.shared_vpc_host_project"]
}

# Create custom network
resource "google_compute_network" "shared_vpc" {
  name                    = "${var.project_base_id}-vpc"
  project                 = "${google_project.shared_vpc_host_project.project_id}"
  auto_create_subnetworks = false
  depends_on              = ["google_project.shared_vpc_host_project", "google_project_service.shared_vpc_api"]

}

# Create subnets

resource "google_compute_subnetwork" "shared_vpc_subnet" {
  count                    = "${length(var.subnet_names)}"
  name                     = "${var.subnet_names[count.index]}"
  project                  = "${google_project.shared_vpc_host_project.project_id}"
  network                  = "${google_compute_network.shared_vpc.self_link}"
  ip_cidr_range            = "${var.subnet_cidr[count.index]}"
  region                   = "${var.subnet_region[count.index]}"
  private_ip_google_access = "${var.subnet_private_ip_google_access}"

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
  depends_on = ["google_compute_network.shared_vpc", "google_project.shared_vpc_host_project", "google_project_service.shared_vpc_api"]
}

# Mark project as host VPC project and create DNS records
resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  project    = "${google_project.shared_vpc_host_project.project_id}"
  depends_on = ["google_project.shared_vpc_host_project"]

resource "google_dns_managed_zone" "private-zone" {
  name        = "private-zone"
  dns_name    = var.private_dns_zones
  description = "Example private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.network-1.id
    }
    networks {
      network_url = google_compute_network.network-2.id
    }
  }
}

resource "google_dns_managed_zone" "public-zone" {
  name        = "public-zone"
  dns_name    = var.public_dns_zones
  description = "Example private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "public"

  private_visibility_config {
    networks {
      network_url = google_compute_network.network-1.id
    }
    networks {
      network_url = google_compute_network.network-2.id
    }
  }
}
  # provisioner "local-exec" {
  #   command = <<EOF
  #     ${path.module}/create-dns.sh \
  #       ${google_project.shared_vpc_host_project.project_id} \
  #       "${join("|", var.private_dns_zones)}" \
  #       "${join("|", var.private_dns_zone_names)}" \
  #       "${join("|", var.private_dns_zone_descriptions)}" \
  #       "${google_compute_network.shared_vpc.name}" \
  #       "${join("|", var.private_a_records)}" \
  #       "${var.inbound_dns_forwarding_policy_name}" \
  #       "${var.inbound_dns_forwarding_policy_desc}" 
  #   EOF
  # }

  # provisioner "local-exec" {
  #   when = "destroy"

  #   command = <<EOF
  #     ${path.module}/destroy-dns.sh \
  #       "${google_project.shared_vpc_host_project.project_id}" \
  #       "${join("|", var.private_dns_zones)}" \
  #       "${var.inbound_dns_forwarding_policy_name}"
  #   EOF
  # }
}
