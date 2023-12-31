resource "kubernetes_secret" "consul_secrets" {
  metadata {
    name = "${var.cluster_id}-hcp"
    namespace  = "consul"
  }

  data = {
    caCert              = var.consul_ca_file
    gossipEncryptionKey = var.gossip_encryption_key
    bootstrapToken      = var.boostrap_acl_token
  }

  type = "Opaque"
}

resource "helm_release" "consul" {
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com"
  version    = var.chart_version
  chart      = "consul"
  namespace  = "consul"

  values = [
    templatefile("${path.module}/template/consul.tpl", {
      datacenter       = var.datacenter
      consul_hosts     = jsonencode(var.consul_hosts)
      cluster_id       = var.cluster_id
      k8s_api_endpoint = var.k8s_api_endpoint
      consul_version   = substr(var.consul_version, 1, -1)
    })
  ]

  # Helm installation relies on the Kubernetes secret being
  # available.
  depends_on = [kubernetes_secret.consul_secrets]
}