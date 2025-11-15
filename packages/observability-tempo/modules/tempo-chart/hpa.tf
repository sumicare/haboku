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


resource "kubernetes_horizontal_pod_autoscaler" "release_name_tempo_compactor" {
  metadata {
    name      = "release-name-tempo-compactor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "compactor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-tempo-compactor"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = 100
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_tempo_distributor" {
  metadata {
    name      = "release-name-tempo-distributor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "distributor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-tempo-distributor"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = 60
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_tempo_querier" {
  metadata {
    name      = "release-name-tempo-querier"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "querier"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-tempo-querier"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = 60
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_tempo_query_frontend" {
  metadata {
    name      = "release-name-tempo-query-frontend"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "query-frontend"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-tempo-query-frontend"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = 60
        }
      }
    }
  }
}

