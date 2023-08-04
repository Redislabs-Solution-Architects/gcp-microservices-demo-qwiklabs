resource "null_resource" "set_gke_creds" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --region ${var.gcp_region} --project ${var.gcp_project_id}"
  }
}

resource "null_resource" "deploy_redis_enterprise_k8" {
  depends_on = [
    null_resource.set_gke_creds
  ]
  provisioner "local-exec" {
    command = <<-EOT
        kubectl create namespace redis && \
        kubectl config set-context --current --namespace=redis && \
        VERSION=v6.4.2-4 && \
        kubectl apply -f https://raw.githubusercontent.com/RedisLabs/redis-enterprise-k8s-docs/$VERSION/bundle.yaml
    EOT
  }
}


data "template_file" "redis_enterprise_k8_cluster" {
  template = file("${path.module}/templates/redis-enterprise-k8/rec.yaml")
}

resource "null_resource" "deploy_redis_enterprise_cluster" {
  depends_on = [
    null_resource.set_gke_creds,
    null_resource.deploy_redis_enterprise_k8
  ]
  provisioner "local-exec" {
    command = <<-EOT
        cat <<-EOF | kubectl apply -f -
        ${data.template_file.redis_enterprise_k8_cluster.rendered}
        EOF
    EOT
  }
}

data "template_file" "redis_enterprise_k8_database" {
  template = file("${path.module}/templates/redis-enterprise-k8/redb.yaml")
}

resource "null_resource" "deploy_redis_enterprise_database" {
  depends_on = [
    null_resource.set_gke_creds,
    null_resource.deploy_redis_enterprise_cluster
  ]
  provisioner "local-exec" {
    command = <<-EOT
        cat <<-EOF | kubectl apply -f -
        ${data.template_file.redis_enterprise_k8_database.rendered}
        EOF
    EOT
  }
}


data "external" "env" {
  depends_on = [ 
    null_resource.deploy_redis_enterprise_database
  ]
  program = ["${path.module}/env.sh"]
}

