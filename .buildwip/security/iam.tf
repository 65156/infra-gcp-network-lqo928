# IAM Bindings
resource "google_folder_iam_binding" "data_binding" {
  folder = google_folder.data.name
  count  = "${length(local.test_roles)}"
  role   = local.test_roles[count.index]
  members = [
    "group:ice@ofx.com",
  ]
}

# IAM Bindings
resource "google_project_iam_member" "project" {
  project = "chicago-stage-948412"
  role    = "roles/editor"
  member  = "group:gcp-role-data-analysis@ofx.com"
}


resource "google_project_iam_policy" "project-chicago-stage-948412" {
  project     = "your-project-id"
  policy_data = data.google_iam_policy.project-chicago-stage-948412.policy_data
}

data "google_iam_policy" "project-chicago-stage-948412" {
  binding {
    role = [ 
        "roles/editor"
    ]
    members = [
        "group:gcp-role-data-analysis@ofx.com" 
    ]
  }
}