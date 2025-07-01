resource "kubernetes_namespace" "web" {
  metadata {
    name = "web"
  }
}

resource "kubernetes_namespace" "database" {
  metadata {
    name = "database"
  }
}

resource "kubernetes_namespace" "automation" {
  metadata {
    name = "automation"
  }
}
