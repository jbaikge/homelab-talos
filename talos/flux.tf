resource "kubernetes_namespace" "flux" {
  metadata {
    name = var.flux_namespace
  }

  depends_on = [
    data.talos_cluster_health.this,
  ]
}

resource "kubernetes_secret" "sops_age" {
  metadata {
    name      = "sops-age"
    namespace = var.flux_namespace
  }

  data = {
    "age.agekey" = file(var.age_key_path)
  }

  depends_on = [
    kubernetes_namespace.flux,
  ]
}

resource "flux_bootstrap_git" "this" {
  embedded_manifests = true
  path               = "clusters/hardwood"
  namespace          = var.flux_namespace

  depends_on = [
    kubernetes_secret.sops_age,
  ]
}
