variable "gcp_project_id" {
  description = "The project ID to deploy the cluter into"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "boutique"
}

variable "gcp_region" {
  description = "The region to deploy the cluster in"
  type        = string
  default     = "us-central1"
}

variable "gke_node_count" {
  description = "The number of nodes to deploy in the cluster"
  type        = number
  default     = 1
}

variable "gke_release_channel" {
  description = "The gke release channel to deploy"
  type        = string
  default     = "RAPID"
}

variable "gke_machine_type" {
  description = "The type of machine to deploy"
  type        = string
  default     = "e2-standard-4"
}

variable "redis_db_type" {
  description = "The type of Redis DB to be setup by default. Valid options are 'OSS' or 'Ent'"
  default     = "OSS"
  type        = string
}
