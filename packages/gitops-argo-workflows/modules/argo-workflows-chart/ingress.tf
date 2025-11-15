
















resource "kubernetes_ingress_v1" "release_name_argo_workflows_server" {
  metadata {
    name      = "release-name-argo-workflows-server"
    namespace = "argo-workflows"

    labels = {
      app                            = "server"
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-server"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }

    annotations = {
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = ["argo-workflows.example.com"]
      secret_name = "argo-workflows-tls"
    }

    rule {
      host = "argo-workflows.example.com"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "release-name-argo-workflows-server"

              port {
                number = 2746
              }
            }
          }
        }
      }
    }
  }
}


