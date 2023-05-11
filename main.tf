terraform {
  required_providers {
    rediscloud = {
      source = "RedisLabs/rediscloud"
    }
  }
}

module "gcp-networking" {
  source         = "./modules/gcp-networking"
  cluster_name   = format("gke-%s", var.cluster_name)
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
}

module "gke-cluster" {
  depends_on = [
    module.gcp-networking
  ]
  source              = "./modules/gke-cluster"
  cluster_name        = format("gke-%s", var.cluster_name)
  gcp_project_id      = var.gcp_project_id
  gcp_region          = var.gcp_region
  gke_node_count      = var.gke_node_count
  gke_release_channel = var.gke_release_channel
  gke_machine_type    = var.gke_machine_type
  gcp_network_name    = module.gcp-networking.gcp_network_name
  gcp_subnet_name     = module.gcp-networking.gcp_subnet_name
}


module "redis-enterprise" {
  depends_on = [
    module.gke-cluster,
  ]
  source                  = "./modules/redis-enterprise"
  cluster_name            = format("gke-%s", var.cluster_name)
  gcp_region              = var.gcp_region
  gcp_project_id          = var.gcp_project_id
}


locals {
  redis_connection_string = "redis-cart:6379"
}

#locals {
#  redis_connection_string = lower(var.redis_db_type) == "ent" ? module.redis-enterprise.redis_connection_string : "redis-cart:6379"
#}

module "microservices" {
  depends_on = [
    module.gke-cluster,
    module.redis-enterprise
  ]
  source                  = "./modules/microservices"
  cluster_name            = format("gke-%s", var.cluster_name)
  gcp_region              = var.gcp_region
  gcp_project_id          = var.gcp_project_id
  redis_connection_string = local.redis_connection_string
  redis_db_type           = lower(var.redis_db_type)
}

