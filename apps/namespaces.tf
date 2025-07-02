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

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
    annotations = {
      name = "ingress"
    }
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
