resource "flux_bootstrap_git" "this" {
  embedded_manifests = true
  path               = "cluster"

  depends_on = [
    data.talos_cluster_health.this,
  ]
}
