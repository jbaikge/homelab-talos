resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }

  depends_on = [
    data.talos_cluster_health.this,
  ]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.18.2"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name

  values = [
    templatefile("${path.module}/config/cert-manager.yml", {
    }),
  ]
}

# Self-Signed certificate to see how this goes
# Ref: https://cloud.theodo.com/en/blog/traefik-kubernetes-certmanager
# resource "kubectl_manifest" "cert_manager_self_cluster_issuer" {
#   yaml_body = templatefile("${path.module}/config/cert-manager-self-cluster-issuer.yml", {
#   })

#   depends_on = [
#     helm_release.cert_manager,
#   ]
# }

# resource "kubectl_manifest" "cert_manager_self_certificate" {
#   yaml_body = templatefile("${path.module}/config/cert-manager-self-certificate.yml", {
#     domain    = var.domain
#     namespace = kubernetes_namespace.traefik.metadata[0].name
#   })

#   depends_on = [
#     kubectl_manifest.cert_manager_self_cluster_issuer,
#   ]
# }

# Let's Encrypt Certificate
# Ref: https://cert-manager.io/docs/usage/certificate/
# Ref: https://cloudprodigy.ca/configure-letsencrypt-and-cert-manager-with-kubernetes/
resource "kubernetes_secret" "cert_manager_credentials" {
  metadata {
    name      = "cert-manager-credentials"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }
  data = {
    "access-key-id"     = data.sops_file.secrets.data["cert-manager.aws.key_id"]
    "secret-access-key" = data.sops_file.secrets.data["cert-manager.aws.secret"]
  }
}

resource "kubectl_manifest" "cert_manager_le_cluster_issuer" {
  yaml_body = templatefile("${path.module}/config/cert-manager-le-cluster-issuer.yml", {
    namespace   = kubernetes_namespace.cert_manager.metadata[0].name
    email       = data.sops_file.secrets.data["cert-manager.acme.email"]
    server      = data.sops_file.secrets.data["cert-manager.acme.server"]
    aws_region  = data.sops_file.secrets.data["cert-manager.aws.region"]
    secret_name = kubernetes_secret.cert_manager_credentials.metadata[0].name
  })

  depends_on = [
    kubernetes_secret.cert_manager_credentials,
  ]
}

resource "kubectl_manifest" "cert_manager_le_certificate" {
  yaml_body = templatefile("${path.module}/config/cert-manager-le-certificate.yml", {
    domain    = var.domain
    namespace = kubernetes_namespace.traefik.metadata[0].name
  })

  depends_on = [
    kubectl_manifest.cert_manager_le_cluster_issuer,
  ]
}
