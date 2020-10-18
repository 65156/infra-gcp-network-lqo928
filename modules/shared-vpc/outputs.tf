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
    id              = ["${google_compute_subnetwork.shared_vpc_subnet.*.id}"]
  }
}
output "subnet_gateway_addresses" {
  value = ["${google_compute_subnetwork.shared_vpc_subnet.*.gateway_address}"]
}

output "subnet_links" {
  value = ["${google_compute_subnetwork.shared_vpc_subnet.*.self_link}"]
}

output "subnet_ids" {
  value = ["${google_compute_subnetwork.shared_vpc_subnet.*.id}"]
}

output "vpc_network" {
  value = "${google_compute_network.shared_vpc.self_link}"
}
output "nat_ips" {
  value = ["${google_compute_address.nat_ip_0.*.address}","${google_compute_address.nat_ip_1.*.address}"]
}
