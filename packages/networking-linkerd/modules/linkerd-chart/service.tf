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


resource "kubernetes_service" "linkerd_identity" {
  metadata {
    name      = "linkerd-identity"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "grpc"
      port        = 8080
      target_port = "8080"
    }

    selector = {
      "linkerd.io/control-plane-component" = "identity"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "linkerd_identity_headless" {
  metadata {
    name      = "linkerd-identity-headless"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "grpc"
      port        = 8080
      target_port = "8080"
    }

    selector = {
      "linkerd.io/control-plane-component" = "identity"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "linkerd_dst" {
  metadata {
    name      = "linkerd-dst"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "grpc"
      port        = 8086
      target_port = "8086"
    }

    selector = {
      "linkerd.io/control-plane-component" = "destination"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "linkerd_dst_headless" {
  metadata {
    name      = "linkerd-dst-headless"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "grpc"
      port        = 8086
      target_port = "8086"
    }

    selector = {
      "linkerd.io/control-plane-component" = "destination"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "linkerd_sp_validator" {
  metadata {
    name      = "linkerd-sp-validator"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "sp-validator"
      port        = 443
      target_port = "sp-validator"
    }

    selector = {
      "linkerd.io/control-plane-component" = "destination"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "linkerd_policy" {
  metadata {
    name      = "linkerd-policy"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "grpc"
      port        = 8090
      target_port = "8090"
    }

    selector = {
      "linkerd.io/control-plane-component" = "destination"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "linkerd_policy_validator" {
  metadata {
    name      = "linkerd-policy-validator"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "policy-https"
      port        = 443
      target_port = "policy-https"
    }

    selector = {
      "linkerd.io/control-plane-component" = "destination"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "linkerd_proxy_injector" {
  metadata {
    name      = "linkerd-proxy-injector"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "proxy-injector"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "config.linkerd.io/opaque-ports" = "443"
      "linkerd.io/created-by"          = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "proxy-injector"
      port        = 443
      target_port = "proxy-injector"
    }

    selector = {
      "linkerd.io/control-plane-component" = "proxy-injector"
    }

    type = "ClusterIP"
  }
}

