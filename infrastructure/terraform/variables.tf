variable "gcp_credentials_file" {
  description = "Path to the Google Cloud service account JSON file"
}

variable "gcp_project" {
  description = "Google Cloud project ID"
}

variable "gcp_region" {
  description = "Google Cloud region"
  default     = "us-east1"
}

variable "container_image" {
  description = "Docker image URL in GCR (e.g., gcr.io/<project-id>/<image-name>)"
}

variable "api_allowed_users" {
  description = "List of users allowed to access the API"
  type        = list(string)
}