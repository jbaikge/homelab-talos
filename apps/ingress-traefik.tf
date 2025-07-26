/*
resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = "36.2.0"
  namespace  = kubernetes_namespace.ingress.metadata[0].name

  values = [
    file("ingress-traefik.yml"),
  ]
}
*/
