resource "null_resource" "set_gke_creds" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --region ${var.gcp_region} --project ${var.gcp_project_id}"
  }
}

data "template_file" "online_boutique" {
  template = file("${path.module}/templates/online-boutique/k8-manifests.yaml")
  vars = {
    redis_connection_string = var.redis_connection_string
  }
}

resource "null_resource" "deploy_online_boutique" {
  provisioner "local-exec" {
    command = <<-EOT
        kubectl config set-context --current --namespace=default && \
        cat <<-EOF | kubectl apply -f -
        ${data.template_file.online_boutique.rendered}
        EOF
    EOT
  }
}
