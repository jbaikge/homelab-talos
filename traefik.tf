resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }

  depends_on = [
    data.talos_cluster_health.this,
  ]
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = "36.3.0"
  namespace  = kubernetes_namespace.traefik.metadata[0].name

  values = [
    templatefile("${path.module}/config/traefik.yml", {
      domain = var.domain
    }),
  ]

  depends_on = [
    kubectl_manifest.L2Advertisement,
  ]
}
