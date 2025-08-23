resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io"
  chart      = "cilium"
  version    = "1.18.1"
  namespace  = "kube-system"

  values = [
    file("${path.module}/files/cilium.yaml"),
  ]

  depends_on = [
    local_file.kubeconfig,
  ]
}
