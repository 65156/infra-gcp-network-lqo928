
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = "10.32.24.0"
  prefix_length = 24
  project       = "barbados-dev-583929"
  network       = module.dev_network.vpc_network
}

resource "google_service_networking_connection" "foobar" {
  network                 = module.dev_network.vpc_network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}