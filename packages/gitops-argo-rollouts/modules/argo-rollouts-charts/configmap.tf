resource "kubernetes_config_map" "configmap_argo_rollouts_argo_rollouts_config" {
  metadata {
    name      = "argo-rollouts-config"
    namespace = "argo-rollouts"

    labels = {
      "app.kubernetes.io/component" = "rollouts-controller"
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name" = "argo-rollouts"
      "app.kubernetes.io/part-of" = "argo-rollouts"
      "app.kubernetes.io/version" = "v1.8.3"
      "helm.sh/chart" = "argo-rollouts-2.40.5"
    }
  }

  data = {
    "trafficRouterPlugins" = <<-EOT
    - args:
    - -kubeClientQPS=40
    - -kubeClientBurst=80
    location: https://github.com/argoproj-labs/rollouts-plugin-trafficrouter-gatewayapi/releases/download/v0.8.0/gatewayapi-plugin-linux_amd64
    name: argoproj-labs/gatewayAPI
    EOT
  }
}


resource "kubernetes_config_map" "configmap_argo_rollouts_argo_rollouts_notification_configmap" {
  metadata {
    name      = "argo-rollouts-notification-configmap"
    namespace = "argo-rollouts"

    labels = {
      "app.kubernetes.io/component" = "rollouts-controller"
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name" = "argo-rollouts"
      "app.kubernetes.io/part-of" = "argo-rollouts"
      "app.kubernetes.io/version" = "v1.8.3"
      "helm.sh/chart" = "argo-rollouts-2.40.5"
    }
  }

  data = {
    "service.slack" = <<-EOT
    token: $slack-token
    EOT
    "subscriptions" = <<-EOT
    - recipients:
    - slack:'xxx'
    triggers:
    - on-rollout-completed
    - on-rollout-aborted
    EOT
    "template.my-purple-template" = <<-EOT
    message: |
    Rollout {{.rollout.metadata.name}} has purple image
    slack:
    attachments: |
    [{
    "title": "{{ .rollout.metadata.name}}",
    "color": "#800080"
    }]
    EOT
    "trigger.on-purple" = <<-EOT
    - send: [my-purple-template]
    when: rollout.spec.template.spec.containers[0].image == 'argoproj/rollouts-demo:purple'
    EOT
  }
}


