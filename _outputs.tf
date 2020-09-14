output "development_subnetworks" {
  value = "${module.dev_network.subnet_links}"
}
output "development_vpc_network" {
  value = "${module.dev_network.vpc_network}"
}
output "staging_subnetworks" {
  value = "${module.stage_network.subnet_links}"
}
output "staging_vpc_network" {
  value = "${module.stage_network.vpc_network}"
}
output "production_subnetworks" {
  value = "${module.prod_network.subnet_links}"
}
output "production_vpc_network" {
  value = "${module.prod_network.vpc_network}"
}
output "management_subnetworks" {
  value = "${module.management_network.subnet_links}"
}
output "management_vpc_network" {
  value = "${module.management_network.vpc_network}"
}

