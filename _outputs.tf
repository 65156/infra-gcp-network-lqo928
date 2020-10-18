output "development_subnetworks" {
  value = "${module.dev_network.subnet_links}"
}
output "development_vpc_network" {
  value = "${module.dev_network.vpc_network}"
}
output "development_project" {
  value = "${module.dev_network.project_id}"
}
output "staging_subnetworks" {
  value = "${module.stage_network.subnet_links}"
}
output "staging_vpc_network" {
  value = "${module.stage_network.vpc_network}"
}
output "staging_project" {
  value = "${module.stage_network.project_id}"
}
output "production_subnetworks" {
  value = "${module.prod_network.subnet_links}"
}
output "production_vpc_network" {
  value = "${module.prod_network.vpc_network}"
}
output "production_project" {
  value = "${module.prod_network.project_id}"
}
output "management_subnetworks" {
  value = "${module.management_network.subnet_links}"
}
output "management_vpc_network" {
  value = "${module.management_network.vpc_network}"
}
output "management_project" {
  value = "${module.management_network.project_id}"
}
output "infrastructure_bucket" {
  value = google_storage_bucket.bucket
}
output "management_nat_ips" {
  value = "${module.management_network.nat_ips}"
}
output "production_nat_ips" {
  value = "${module.prod_network.nat_ips}"
}
output "development_nat_ips" {
  value = "${module.dev_network.nat_ips}"
}
output "staging_nat_ips" {
  value = "${module.stage_network.nat_ips}"
}
