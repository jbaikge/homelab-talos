resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }

  depends_on = [
    data.talos_cluster_health.this,
  ]
}

resource "kubernetes_secret" "traefik_cert" {
  metadata {
    name      = "local-selfsigned-tls"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }
  data = {
    "tls.crt" = data.sops_file.secrets.data["cert.cert"]
    "tls.key" = data.sops_file.secrets.data["cert.key"]
  }
  type = "kubernetes.io/tls"
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = "36.2.0"
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
