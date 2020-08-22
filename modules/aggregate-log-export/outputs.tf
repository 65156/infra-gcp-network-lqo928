output "log_sink_resource_id" {
  value = module.log_export.log_sink_resource_id
}

output "log_sink_resource_name" {
  value = module.log_export.log_sink_resource_name
}

output "service_account" {
  value = google_service_account.service_account.name
}