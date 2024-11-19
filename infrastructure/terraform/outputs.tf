output "cloud_run_url" {
  value = google_cloud_run_service.node_service.status[0].url
}