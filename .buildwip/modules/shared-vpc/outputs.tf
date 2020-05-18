# TODO 
output "project_id" {
  value = "${google_project.shared_vpc_host_project.project_id}"
}

output "project_number" {
  value = "${google_project.shared_vpc_host_project.number}"
}

output "network" {
  value = {
    gateway_ipv4 = "${google_compute_network.shared_vpc.gateway_ipv4}"
    name         = "${google_compute_network.shared_vpc.name}"
    link         = "${google_compute_network.shared_vpc.self_link}"
  }
}

output "subnets" {
  value = {
    gateway_address = ["${google_compute_subnetwork.shared_vpc_subnet.*.gateway_address}"]
    fingerprint     = ["${google_compute_subnetwork.shared_vpc_subnet.*.fingerprint}"]
    link            = ["${google_compute_subnetwork.shared_vpc_subnet.*.self_link}"]
  }
}

output "subnet_gateway_addresses" {
  value = ["${google_compute_subnetwork.shared_vpc_subnet.*.gateway_address}"]
}

output "subnet_links" {
  value = ["${google_compute_subnetwork.shared_vpc_subnet.*.self_link}"]
}

output "vpc_network" {
  value = "${google_compute_network.shared_vpc.self_link}"
}
