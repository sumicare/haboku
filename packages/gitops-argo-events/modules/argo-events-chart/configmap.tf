resource "kubernetes_manifest" "configmap_argo_events_release_name_argo_events_controller_manager" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "controller-config.yaml" = <<-EOT
      eventBus:
        nats:
          versions:
          - version: latest
            natsStreamingImage: nats-streaming:latest
            metricsExporterImage: natsio/prometheus-nats-exporter:latest
          - version: 0.22.1
            natsStreamingImage: nats-streaming:0.22.1
            metricsExporterImage: natsio/prometheus-nats-exporter:0.8.0
        jetstream:
          # Default JetStream settings, could be overridden by EventBus JetStream specs
          settings: |
            # https://docs.nats.io/running-a-nats-service/configuration#jetstream
            # Only configure "max_memory_store" or "max_file_store", do not set "store_dir" as it has been hardcoded.
            max_memory_store: -1
            max_file_store: -1
          # The default properties of the streams to be created in this JetStream service
          streamConfig: |
            maxMsgs: 1e+06
            maxAge: 72h
            maxBytes: 1GB
            replicas: 3
            duplicates: 300s
            retention: 0
            discard: 0
          versions:
          - version: 2.10.10
            natsImage: nats:2.10.10
            metricsExporterImage: natsio/prometheus-nats-exporter:0.14.0
            configReloaderImage: natsio/nats-server-config-reloader:0.14.0
            startCommand: /nats-server
      
      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "argo-events-controller-manager"
        "app.kubernetes.io/part-of"    = "argo-events"
        "helm.sh/chart"                = "argo-events-2.4.16"
      }
      "name"      = "release-name-argo-events-controller-manager"
      "namespace" = "argo-events"
    }
  }
}
