resource "kubernetes_namespace" "automation" {
  metadata {
    name = "automation"
    annotations = {
      name = "automation"
    }
  }
}

resource "kubernetes_namespace" "database" {
  metadata {
    name = "database"
    annotations = {
      name = "database"
    }
  }
}

resource "kubernetes_namespace" "metallb-system" {
  # depends_on = [data.talos_cluster_health.health]
  metadata {
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }
    name = "metallb-system"
  }
}

resource "kubernetes_namespace" "web" {
  metadata {
    name = "web"
    annotations = {
      name = "web"
    }
  }
}
