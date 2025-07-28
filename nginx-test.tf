resource "kubernetes_namespace" "nginx-test" {
  metadata {
    name = "nginx-test"
  }
}

resource "kubernetes_deployment" "nginx-test" {
  metadata {
    name      = "nginx-test"
    namespace = kubernetes_namespace.nginx-test.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx-test"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx-test"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx-test" {
  metadata {
    name      = "nginx-test"
    namespace = kubernetes_namespace.nginx-test.metadata[0].name
  }
  spec {
    selector = {
      app = "nginx-test"
    }
    port {
      port = 80
    }
  }

  depends_on = [
    kubernetes_deployment.nginx-test,
  ]
}

resource "kubernetes_manifest" "nginx-test_httproute" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "nginx-test"
      namespace = kubernetes_namespace.nginx-test.metadata[0].name
    }
    spec = {
      parentRefs = [
        {
          name      = "traefik-gateway"
          namespace = kubernetes_namespace.traefik.metadata[0].name
        },
      ]
      hostnames = [
        "nginx-test.${var.domain}",
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
              name = "nginx-test"
              port = 80
            },
          ]
        },
      ]
    }
  }
}
