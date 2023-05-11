output "gke_cluster_name" {
  value       = module.gke-cluster.gke_cluster_name
  description = "The name of the GKE cluster"
}

output "region" {
  value       = module.gke-cluster.region
  description = "The Region the GKE cluster is deployed"
}

output "db_private_endpoint" {
  value       = module.redis-enterprise.db_private_endpoint
  description = "The Redis DB Enterprise endpoint"
}

output "db_password" {
  value       = module.redis-enterprise.db_password
  sensitive   = true
  description = "The Redis Enterprise DB Password"
}

