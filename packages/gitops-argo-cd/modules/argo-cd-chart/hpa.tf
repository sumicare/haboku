/*
   Copyright 2025 Sumicare

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/


resource "kubernetes_horizontal_pod_autoscaler" "release_name_argocd_repo_server" {
  metadata {
    name      = "release-name-argocd-repo-server"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "repo-server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-repo-server"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-argocd-repo-server"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 5

    metric {
      type = "External"

      external {
        metric {
          name = "argocd_repo_pending_request_total"

          selector {
            match_labels = {
              "app.kubernetes.io/name" = "argocd-repo-server"
            }
          }
        }

        target {
          type = "AverageValue"
        }
      }
    }

    metric {
      type = "External"

      external {
        metric {
          name = "argocd_git_request_total"

          selector {
            match_labels = {
              "app.kubernetes.io/name" = "argocd-repo-server"
            }
          }
        }

        target {
          type = "AverageValue"
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_argocd_server" {
  metadata {
    name      = "release-name-argocd-server"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-server"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-argocd-server"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 5

    metric {
      type = "External"

      external {
        metric {
          name = "argocd_repo_pending_request_total"

          selector {
            match_labels = {
              "app.kubernetes.io/name" = "argocd-repo-server"
            }
          }
        }

        target {
          type = "AverageValue"
        }
      }
    }

    metric {
      type = "External"

      external {
        metric {
          name = "argocd_git_request_total"

          selector {
            match_labels = {
              "app.kubernetes.io/name" = "argocd-repo-server"
            }
          }
        }

        target {
          type = "AverageValue"
        }
      }
    }
  }
}
