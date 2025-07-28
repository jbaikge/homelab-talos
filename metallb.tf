resource "kubernetes_namespace" "metallb-system" {
  metadata {
    name = "metallb-system"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }
  }

  depends_on = [
    data.talos_cluster_health.this,
  ]
}

resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = "0.15.2"
  namespace  = kubernetes_namespace.metallb-system.metadata[0].name
  values = [
    file("${path.module}/config/metallb.yml"),
  ]

  depends_on = [
    kubernetes_namespace.metallb-system
  ]
}

resource "kubectl_manifest" "IPAddressPool" {
  yaml_body = templatefile("${path.module}/config/metallb-IPAddressPool.yml", {
    namespace = kubernetes_namespace.metallb-system.metadata[0].name
    address   = "${var.vip}/32"
  })

  depends_on = [
    helm_release.metallb,
  ]
}

resource "kubectl_manifest" "L2Advertisement" {
  yaml_body = templatefile("${path.module}/config/metallb-L2Advertisement.yml", {
    namespace = kubernetes_namespace.metallb-system.metadata[0].name
  })

  depends_on = [
    kubectl_manifest.IPAddressPool,
  ]
}
