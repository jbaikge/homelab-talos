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
resource "kubectl_manifest" "cert_manager_self_cluster_issuer" {
  yaml_body = templatefile("${path.module}/config/cert-manager-self-cluster-issuer.yml", {
  })

  depends_on = [
    helm_release.cert_manager,
  ]
}

resource "kubectl_manifest" "cert_manager_self_certificate" {
  yaml_body = templatefile("${path.module}/config/cert-manager-self-certificate.yml", {
    domain    = var.domain
    namespace = kubernetes_namespace.traefik.metadata[0].name
  })

  depends_on = [
    kubectl_manifest.cert_manager_self_cluster_issuer,
  ]
}
