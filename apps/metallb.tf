resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = "0.15.2"
  namespace  = kubernetes_namespace.metallb-system.metadata[0].name

  values = [
    file("metallb.yml"),
  ]

  depends_on = [
    kubernetes_namespace.metallb-system,
  ]
}
