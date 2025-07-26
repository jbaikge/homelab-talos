resource "kubernetes_namespace" "whoami" {
  metadata {
    name = "whoami"
  }
}

resource "kubernetes_deployment" "whoami" {
  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.whoami.metadata[0].name
  }
  spec {
    replicas = length(var.workers)
    selector {
      match_labels = {
        app = "whoami"
      }
    }
    template {
      metadata {
        labels = {
          app = "whoami"
        }
      }
      spec {
        container {
          name  = "whoami"
          image = "traefik/whoami"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "whoami" {
  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.whoami.metadata[0].name
  }
  spec {
    selector = {
      app = "whoami"
    }
    port {
      port = 80
    }
  }

  depends_on = [
    kubernetes_deployment.whoami,
  ]
}

resource "kubernetes_manifest" "whoami_httproute" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "whoami"
      namespace = kubernetes_namespace.whoami.metadata[0].name
    }
    spec = {
      parentRefs = [
        {
          name = "traefik-gateway"
        },
      ]
      hostnames = [
        "whoami.${var.domain}",
      ]
      rules = [
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/"
              }
            },
          ]
          backendRefs = [
            {
              name = "whoami"
              port = 80
            },
          ]
        },
      ]
    }
  }

  depends_on = [
    kubernetes_service.whoami,
  ]
}
