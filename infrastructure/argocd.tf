resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "8.3.0"
  namespace        = "argocd"
  create_namespace = true

  depends_on = [
    local_file.kubeconfig,
  ]
}
