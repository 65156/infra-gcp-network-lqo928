# Define Folders
resource "google_folder" "data" {
  display_name = "Data"
  parent       = "organizations/${var.global["org_id"]}"
}
