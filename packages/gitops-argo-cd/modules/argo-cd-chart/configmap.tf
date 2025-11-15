resource "kubernetes_manifest" "configmap_argocd_argocd_cm" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "admin.enabled"                                                                     = "true"
      "application.instanceLabelKey"                                                      = "argocd.argoproj.io/instance"
      "application.sync.impersonation.enabled"                                            = "false"
      "dex.config"                                                                        = <<-EOT
      connectors:
        # GitHub OAuth connector
        - type: github
          id: github
          name: GitHub
          config:
            clientID: $dex.github.clientID
            clientSecret: $dex.github.clientSecret
            orgs:
            - name: sumicare
            # Optional: Restrict to specific teams within the org
            # teams:
            # - team-name

      EOT
      "exec.enabled"                                                                      = "false"
      "resource.customizations.ignoreResourceUpdates.ConfigMap"                           = <<-EOT
      jqPathExpressions:
        # Ignore the cluster-autoscaler status
        - '.metadata.annotations."cluster-autoscaler.kubernetes.io/last-updated"'
        # Ignore the annotation of the legacy Leases election
        - '.metadata.annotations."control-plane.alpha.kubernetes.io/leader"'

      EOT
      "resource.customizations.ignoreResourceUpdates.Endpoints"                           = <<-EOT
      jsonPointers:
        - /metadata
        - /subsets

      EOT
      "resource.customizations.ignoreResourceUpdates.all"                                 = <<-EOT
      jsonPointers:
        - /status

      EOT
      "resource.customizations.ignoreResourceUpdates.apps_ReplicaSet"                     = <<-EOT
      jqPathExpressions:
        - '.metadata.annotations."deployment.kubernetes.io/desired-replicas"'
        - '.metadata.annotations."deployment.kubernetes.io/max-replicas"'
        - '.metadata.annotations."rollout.argoproj.io/desired-replicas"'

      EOT
      "resource.customizations.ignoreResourceUpdates.argoproj.io_Application"             = <<-EOT
      jqPathExpressions:
        - '.metadata.annotations."notified.notifications.argoproj.io"'
        - '.metadata.annotations."argocd.argoproj.io/refresh"'
        - '.metadata.annotations."argocd.argoproj.io/hydrate"'
        - '.operation'

      EOT
      "resource.customizations.ignoreResourceUpdates.argoproj.io_Rollout"                 = <<-EOT
      jqPathExpressions:
        - '.metadata.annotations."notified.notifications.argoproj.io"'

      EOT
      "resource.customizations.ignoreResourceUpdates.autoscaling_HorizontalPodAutoscaler" = <<-EOT
      jqPathExpressions:
        - '.metadata.annotations."autoscaling.alpha.kubernetes.io/behavior"'
        - '.metadata.annotations."autoscaling.alpha.kubernetes.io/conditions"'
        - '.metadata.annotations."autoscaling.alpha.kubernetes.io/metrics"'
        - '.metadata.annotations."autoscaling.alpha.kubernetes.io/current-metrics"'

      EOT
      "resource.customizations.ignoreResourceUpdates.discovery.k8s.io_EndpointSlice"      = <<-EOT
      jsonPointers:
        - /metadata
        - /endpoints
        - /ports

      EOT
      "resource.exclusions"                                                               = <<-EOT
      ### Network resources created by the Kubernetes control plane and excluded to reduce the number of watched events and UI clutter
      - apiGroups:
        - ''
        - discovery.k8s.io
        kinds:
        - Endpoints
        - EndpointSlice
      ### Internal Kubernetes resources excluded reduce the number of watched events
      - apiGroups:
        - coordination.k8s.io
        kinds:
        - Lease
      ### Internal Kubernetes Authz/Authn resources excluded reduce the number of watched events
      - apiGroups:
        - authentication.k8s.io
        - authorization.k8s.io
        kinds:
        - SelfSubjectReview
        - TokenReview
        - LocalSubjectAccessReview
        - SelfSubjectAccessReview
        - SelfSubjectRulesReview
        - SubjectAccessReview
      ### Intermediate Certificate Request excluded reduce the number of watched events
      - apiGroups:
        - certificates.k8s.io
        kinds:
        - CertificateSigningRequest
      - apiGroups:
        - cert-manager.io
        kinds:
        - CertificateRequest
      ### Cilium internal resources excluded reduce the number of watched events and UI Clutter
      - apiGroups:
        - cilium.io
        kinds:
        - CiliumIdentity
        - CiliumEndpoint
        - CiliumEndpointSlice
      ### Kyverno intermediate and reporting resources excluded reduce the number of watched events and improve performance
      - apiGroups:
        - kyverno.io
        - reports.kyverno.io
        - wgpolicyk8s.io
        kinds:
        - PolicyReport
        - ClusterPolicyReport
        - EphemeralReport
        - ClusterEphemeralReport
        - AdmissionReport
        - ClusterAdmissionReport
        - BackgroundScanReport
        - ClusterBackgroundScanReport
        - UpdateRequest

      EOT
      "server.rbac.log.enforce.enable"                                                    = "true"
      "statusbadge.enabled"                                                               = "true"
      "statusbadge.url"                                                                   = "https://Sumicare/"
      "timeout.hard.reconciliation"                                                       = "0s"
      "timeout.reconciliation"                                                            = "180s"
      "url"                                                                               = "https://argocd.Sumicare"
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component"  = "server"
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "argocd-cm"
        "app.kubernetes.io/part-of"    = "argocd"
        "app.kubernetes.io/version"    = "v3.1.8"
        "helm.sh/chart"                = "argo-cd-8.6.4"
      }
      "name"      = "argocd-cm"
      "namespace" = "argocd"
    }
  }
}

resource "kubernetes_manifest" "configmap_argocd_argocd_cmd_params_cm" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "application.namespaces"                            = ""
      "applicationsetcontroller.enable.leader.election"   = "true"
      "applicationsetcontroller.enable.progressive.syncs" = "false"
      "applicationsetcontroller.log.format"               = "text"
      "applicationsetcontroller.log.level"                = "info"
      "applicationsetcontroller.namespaces"               = ""
      "applicationsetcontroller.policy"                   = "sync"
      "commitserver.log.format"                           = "text"
      "commitserver.log.level"                            = "info"
      "controller.ignore.normalizer.jq.timeout"           = "1s"
      "controller.log.format"                             = "text"
      "controller.log.level"                              = "info"
      "controller.operation.processors"                   = "10"
      "controller.repo.server.timeout.seconds"            = "60"
      "controller.self.heal.timeout.seconds"              = "5"
      "controller.status.processors"                      = "20"
      "controller.sync.timeout.seconds"                   = "0"
      "dexserver.log.format"                              = "text"
      "dexserver.log.level"                               = "info"
      "hydrator.enabled"                                  = "false"
      "notificationscontroller.log.format"                = "text"
      "notificationscontroller.log.level"                 = "info"
      "otlp.address"                                      = ""
      "redis.server"                                      = "argocd-valkey.argocd.svc.cluster.local:6379"
      "repo.server"                                       = "release-name-argocd-repo-server:8081"
      "reposerver.log.format"                             = "text"
      "reposerver.log.level"                              = "info"
      "reposerver.parallelism.limit"                      = "0"
      "server.basehref"                                   = "/"
      "server.dex.server"                                 = "https://release-name-argocd-dex-server:5556"
      "server.dex.server.strict.tls"                      = "true"
      "server.disable.auth"                               = "false"
      "server.enable.gzip"                                = "true"
      "server.enable.proxy.extension"                     = "false"
      "server.insecure"                                   = "false"
      "server.log.format"                                 = "text"
      "server.log.level"                                  = "info"
      "server.repo.server.strict.tls"                     = "true"
      "server.rootpath"                                   = ""
      "server.staticassets"                               = "/shared/app"
      "server.x.frame.options"                            = "sameorigin"
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component"  = "server"
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "argocd-cmd-params-cm"
        "app.kubernetes.io/part-of"    = "argocd"
        "app.kubernetes.io/version"    = "v3.1.8"
        "helm.sh/chart"                = "argo-cd-8.6.4"
      }
      "name"      = "argocd-cmd-params-cm"
      "namespace" = "argocd"
    }
  }
}

resource "kubernetes_manifest" "configmap_argocd_argocd_cmp_cm" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "sumicare-terraform-cmp.yaml" = <<-EOT
      apiVersion: argoproj.io/v1alpha1
      kind: ConfigManagementPlugin
      metadata:
        name: sumicare-terraform-cmp
      spec:
        discover:
          fileName: ./subdir/s*.yaml
          find:
            command:
            - sh
            - -c
            - find . -name env.yaml
            glob: '**/Chart.yaml'
        generate:
          args:
          - |
            echo "{\"kind\": \"ConfigMap\", \"apiVersion\": \"v1\", \"metadata\": { \"name\": \"$ARGOCD_APP_NAME\", \"namespace\": \"$ARGOCD_APP_NAMESPACE\", \"annotations\": {\"Foo\": \"$ARGOCD_ENV_FOO\", \"KubeVersion\": \"$KUBE_VERSION\", \"KubeApiVersion\": \"$KUBE_API_VERSIONS\",\"Bar\": \"baz\"}}}"
          command:
          - sh
          - -c
        init:
          args:
          - -c
          - echo "Initializing..."
          command:
          - sh

      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component"  = "repo-server"
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "argocd-cmp-cm"
        "app.kubernetes.io/part-of"    = "argocd"
        "app.kubernetes.io/version"    = "v3.1.8"
        "helm.sh/chart"                = "argo-cd-8.6.4"
      }
      "name"      = "argocd-cmp-cm"
      "namespace" = "argocd"
    }
  }
}

resource "kubernetes_manifest" "configmap_argocd_argocd_gpg_keys_cm" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "argocd-gpg-keys-cm"
        "app.kubernetes.io/part-of"    = "argocd"
        "app.kubernetes.io/version"    = "v3.1.8"
        "helm.sh/chart"                = "argo-cd-8.6.4"
      }
      "name"      = "argocd-gpg-keys-cm"
      "namespace" = "argocd"
    }
  }
}

resource "kubernetes_manifest" "configmap_argocd_argocd_notifications_cm" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "context"                          = <<-EOT
      argocdUrl: https://Sumicare

      EOT
      "defaultTriggers"                  = <<-EOT
      - on-sync-status-unknown

      EOT
      "subscriptions"                    = <<-EOT
      - recipients:
        - slack:test2
        - email:test@gmail.com
        triggers:
        - on-sync-status-unknown

      EOT
      "template.app-deployed"            = <<-EOT
      email:
        subject: New version of an application {{.app.metadata.name}} is up and running.
      message: |
        {{if eq .serviceType "slack"}}:white_check_mark:{{end}} Application {{.app.metadata.name}} is now running new version of deployments manifests.
      slack:
        attachments: |
          [{
            "title": "{{ .app.metadata.name}}",
            "title_link":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
            "color": "#18be52",
            "fields": [
            {
              "title": "Sync Status",
              "value": "{{.app.status.sync.status}}",
              "short": true
            },
            {
              "title": "Repository",
              "value": "{{.app.spec.source.repoURL}}",
              "short": true
            },
            {
              "title": "Revision",
              "value": "{{.app.status.sync.revision}}",
              "short": true
            }
            {{range $index, $c := .app.status.conditions}}
            {{if not $index}},{{end}}
            {{if $index}},{{end}}
            {
              "title": "{{$c.type}}",
              "value": "{{$c.message}}",
              "short": true
            }
            {{end}}
            ]
          }]

      EOT
      "template.app-health-degraded"     = <<-EOT
      email:
        subject: Application {{.app.metadata.name}} has degraded.
      message: |
        {{if eq .serviceType "slack"}}:exclamation:{{end}} Application {{.app.metadata.name}} has degraded.
        Application details: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}.
      slack:
        attachments: |-
          [{
            "title": "{{ .app.metadata.name}}",
            "title_link": "{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
            "color": "#f4c030",
            "fields": [
            {
              "title": "Sync Status",
              "value": "{{.app.status.sync.status}}",
              "short": true
            },
            {
              "title": "Repository",
              "value": "{{.app.spec.source.repoURL}}",
              "short": true
            }
            {{range $index, $c := .app.status.conditions}}
            {{if not $index}},{{end}}
            {{if $index}},{{end}}
            {
              "title": "{{$c.type}}",
              "value": "{{$c.message}}",
              "short": true
            }
            {{end}}
            ]
          }]

      EOT
      "template.app-sync-failed"         = <<-EOT
      email:
        subject: Failed to sync application {{.app.metadata.name}}.
      message: |
        {{if eq .serviceType "slack"}}:exclamation:{{end}}  The sync operation of application {{.app.metadata.name}} has failed at {{.app.status.operationState.finishedAt}} with the following error: {{.app.status.operationState.message}}
        Sync operation details are available at: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}?operation=true .
      slack:
        attachments: |-
          [{
            "title": "{{ .app.metadata.name}}",
            "title_link":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
            "color": "#E96D76",
            "fields": [
            {
              "title": "Sync Status",
              "value": "{{.app.status.sync.status}}",
              "short": true
            },
            {
              "title": "Repository",
              "value": "{{.app.spec.source.repoURL}}",
              "short": true
            }
            {{range $index, $c := .app.status.conditions}}
            {{if not $index}},{{end}}
            {{if $index}},{{end}}
            {
              "title": "{{$c.type}}",
              "value": "{{$c.message}}",
              "short": true
            }
            {{end}}
            ]
          }]

      EOT
      "template.app-sync-running"        = <<-EOT
      email:
        subject: Start syncing application {{.app.metadata.name}}.
      message: |
        The sync operation of application {{.app.metadata.name}} has started at {{.app.status.operationState.startedAt}}.
        Sync operation details are available at: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}?operation=true .
      slack:
        attachments: |-
          [{
            "title": "{{ .app.metadata.name}}",
            "title_link":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
            "color": "#0DADEA",
            "fields": [
            {
              "title": "Sync Status",
              "value": "{{.app.status.sync.status}}",
              "short": true
            },
            {
              "title": "Repository",
              "value": "{{.app.spec.source.repoURL}}",
              "short": true
            }
            {{range $index, $c := .app.status.conditions}}
            {{if not $index}},{{end}}
            {{if $index}},{{end}}
            {
              "title": "{{$c.type}}",
              "value": "{{$c.message}}",
              "short": true
            }
            {{end}}
            ]
          }]

      EOT
      "template.app-sync-status-unknown" = <<-EOT
      email:
        subject: Application {{.app.metadata.name}} sync status is 'Unknown'
      message: |
        {{if eq .serviceType "slack"}}:exclamation:{{end}} Application {{.app.metadata.name}} sync is 'Unknown'.
        Application details: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}.
        {{if ne .serviceType "slack"}}
        {{range $c := .app.status.conditions}}
            * {{$c.message}}
        {{end}}
        {{end}}
      slack:
        attachments: |-
          [{
            "title": "{{ .app.metadata.name}}",
            "title_link":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
            "color": "#E96D76",
            "fields": [
            {
              "title": "Sync Status",
              "value": "{{.app.status.sync.status}}",
              "short": true
            },
            {
              "title": "Repository",
              "value": "{{.app.spec.source.repoURL}}",
              "short": true
            }
            {{range $index, $c := .app.status.conditions}}
            {{if not $index}},{{end}}
            {{if $index}},{{end}}
            {
              "title": "{{$c.type}}",
              "value": "{{$c.message}}",
              "short": true
            }
            {{end}}
            ]
          }]

      EOT
      "template.app-sync-succeeded"      = <<-EOT
      email:
        subject: Application {{.app.metadata.name}} has been successfully synced.
      message: |
        {{if eq .serviceType "slack"}}:white_check_mark:{{end}} Application {{.app.metadata.name}} has been successfully synced at {{.app.status.operationState.finishedAt}}.
        Sync operation details are available at: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}?operation=true .
      slack:
        attachments: |-
          [{
            "title": "{{ .app.metadata.name}}",
            "title_link":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
            "color": "#18be52",
            "fields": [
            {
              "title": "Sync Status",
              "value": "{{.app.status.sync.status}}",
              "short": true
            },
            {
              "title": "Repository",
              "value": "{{.app.spec.source.repoURL}}",
              "short": true
            }
            {{range $index, $c := .app.status.conditions}}
            {{if not $index}},{{end}}
            {{if $index}},{{end}}
            {
              "title": "{{$c.type}}",
              "value": "{{$c.message}}",
              "short": true
            }
            {{end}}
            ]
          }]

      EOT
      "trigger.on-deployed"              = <<-EOT
      - description: Application is synced and healthy. Triggered once per commit.
        oncePer: app.status.sync.revision
        send:
        - app-deployed
        when: app.status.operationState.phase in ['Succeeded'] and app.status.health.status == 'Healthy'

      EOT
      "trigger.on-health-degraded"       = <<-EOT
      - description: Application has degraded
        send:
        - app-health-degraded
        when: app.status.health.status == 'Degraded'

      EOT
      "trigger.on-sync-failed"           = <<-EOT
      - description: Application syncing has failed
        send:
        - app-sync-failed
        when: app.status.operationState.phase in ['Error', 'Failed']

      EOT
      "trigger.on-sync-running"          = <<-EOT
      - description: Application is being synced
        send:
        - app-sync-running
        when: app.status.operationState.phase in ['Running']

      EOT
      "trigger.on-sync-status-unknown"   = <<-EOT
      - description: Application status is 'Unknown'
        send:
        - app-sync-status-unknown
        when: app.status.sync.status == 'Unknown'

      EOT
      "trigger.on-sync-succeeded"        = <<-EOT
      - description: Application syncing has succeeded
        send:
        - app-sync-succeeded
        when: app.status.operationState.phase in ['Succeeded']

      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component"  = "notifications-controller"
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "argocd-notifications-controller"
        "app.kubernetes.io/part-of"    = "argocd"
        "app.kubernetes.io/version"    = "v3.1.8"
        "helm.sh/chart"                = "argo-cd-8.6.4"
      }
      "name"      = "argocd-notifications-cm"
      "namespace" = "argocd"
    }
  }
}

resource "kubernetes_manifest" "configmap_argocd_argocd_rbac_cm" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "policy.csv"       = ""
      "policy.default"   = ""
      "policy.matchMode" = "glob"
      "scopes"           = "[groups]"
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component"  = "server"
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "argocd-rbac-cm"
        "app.kubernetes.io/part-of"    = "argocd"
        "app.kubernetes.io/version"    = "v3.1.8"
        "helm.sh/chart"                = "argo-cd-8.6.4"
      }
      "name"      = "argocd-rbac-cm"
      "namespace" = "argocd"
    }
  }
}

resource "kubernetes_manifest" "configmap_argocd_argocd_ssh_known_hosts_cm" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "ssh_known_hosts" = <<-EOT
      [ssh.github.com]:443 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
      [ssh.github.com]:443 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
      [ssh.github.com]:443 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
      bitbucket.org ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPIQmuzMBuKdWeF4+a2sjSSpBK0iqitSQ+5BM9KhpexuGt20JpTVM7u5BDZngncgrqDMbWdxMWWOGtZ9UgbqgZE=
      bitbucket.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIazEu89wgQZ4bqs3d63QSMzYVa0MuJ2e2gKTKqu+UUO
      bitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQeJzhupRu0u0cdegZIa8e86EG2qOCsIsD1Xw0xSeiPDlCr7kq97NLmMbpKTX6Esc30NuoqEEHCuc7yWtwp8dI76EEEB1VqY9QJq6vk+aySyboD5QF61I/1WeTwu+deCbgKMGbUijeXhtfbxSxm6JwGrXrhBdofTsbKRUsrN1WoNgUa8uqN1Vx6WAJw1JHPhglEGGHea6QICwJOAr/6mrui/oB7pkaWKHj3z7d1IC4KWLtY47elvjbaTlkN04Kc/5LFEirorGYVbt15kAUlqGM65pk6ZBxtaO3+30LVlORZkxOh+LKL/BvbZ/iRNhItLqNyieoQj/uh/7Iv4uyH/cV/0b4WDSd3DptigWq84lJubb9t/DnZlrJazxyDCulTmKdOR7vs9gMTo+uoIrPSb8ScTtvw65+odKAlBj59dhnVp9zd7QUojOpXlL62Aw56U4oO+FALuevvMjiWeavKhJqlR7i5n9srYcrNV7ttmDw7kf/97P5zauIhxcjX+xHv4M=
      github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
      github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
      github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
      gitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=
      gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
      gitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9
      ssh.dev.azure.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Hr1oTWqNqOlzGJOfGJ4NakVyIzf1rXYd4d7wo6jBlkLvCA4odBlL0mDUyZ0/QUfTTqeu+tm22gOsv+VrVTMk6vwRU75gY/y9ut5Mb3bR5BV58dKXyq9A9UeB5Cakehn5Zgm6x1mKoVyf+FFn26iYqXJRgzIZZcZ5V6hrE0Qg39kZm4az48o0AUbf6Sp4SLdvnuMa2sVNwHBboS7EJkm57XQPVU3/QpyNLHbWDdzwtrlS+ez30S3AdYhLKEOxAG8weOnyrtLJAUen9mTkol8oII1edf7mWWbWVf0nBmly21+nZcmCTISQBtdcyPaEno7fFQMDD26/s0lfKob4Kw8H
      vs-ssh.visualstudio.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Hr1oTWqNqOlzGJOfGJ4NakVyIzf1rXYd4d7wo6jBlkLvCA4odBlL0mDUyZ0/QUfTTqeu+tm22gOsv+VrVTMk6vwRU75gY/y9ut5Mb3bR5BV58dKXyq9A9UeB5Cakehn5Zgm6x1mKoVyf+FFn26iYqXJRgzIZZcZ5V6hrE0Qg39kZm4az48o0AUbf6Sp4SLdvnuMa2sVNwHBboS7EJkm57XQPVU3/QpyNLHbWDdzwtrlS+ez30S3AdYhLKEOxAG8weOnyrtLJAUen9mTkol8oII1edf7mWWbWVf0nBmly21+nZcmCTISQBtdcyPaEno7fFQMDD26/s0lfKob4Kw8H

      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "argocd-ssh-known-hosts-cm"
        "app.kubernetes.io/part-of"    = "argocd"
        "app.kubernetes.io/version"    = "v3.1.8"
        "helm.sh/chart"                = "argo-cd-8.6.4"
      }
      "name"      = "argocd-ssh-known-hosts-cm"
      "namespace" = "argocd"
    }
  }
}

resource "kubernetes_manifest" "configmap_argocd_argocd_tls_certs_cm" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "argocd-tls-certs-cm"
        "app.kubernetes.io/part-of"    = "argocd"
        "app.kubernetes.io/version"    = "v3.1.8"
        "helm.sh/chart"                = "argo-cd-8.6.4"
      }
      "name"      = "argocd-tls-certs-cm"
      "namespace" = "argocd"
    }
  }
}
