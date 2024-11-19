terraform {
  backend "gcs" {
    bucket  = "pgmt-mgmt-terraform-state-bucket"
    prefix  = "terraform/state"
  }
}

resource "google_project_service" "cloud_resource_manager_api" {
  project = var.gcp_project
  service = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_run_api" {
  project = var.gcp_project
  service = "run.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.cloud_resource_manager_api]
}

resource "google_cloud_run_service" "node_service" {
  name     = "node-service"
  location = var.gcp_region

  template {
    spec {
      containers {
        image = var.container_image
        resources {
          limits = {
            memory = "512Mi"
            cpu    = "1"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_policy" "public_access" {
  location = google_cloud_run_service.node_service.location
  project  = google_cloud_run_service.node_service.project
  service  = google_cloud_run_service.node_service.name

  policy_data = <<EOF
{
  "bindings": [
    {
      "role": "roles/run.invoker",
      "members": [
        "allUsers"
      ]
    }
  ]
}
EOF
}