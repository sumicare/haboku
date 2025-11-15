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


resource "kubernetes_config_map" "release_name_argo_workflows_workflow_controller_configmap" {
  metadata {
    name      = "release-name-argo-workflows-workflow-controller-configmap"
    namespace = "argo-workflows"

    labels = {
      app                            = "workflow-controller"
      "app.kubernetes.io/component"  = "workflow-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-cm"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  data = {
    config = "artifactRepository:\n  archiveLogs: true\n  s3:\n    accessKeySecret:\n      key: accesskey\n      name: release-name-minio\n    secretKeySecret:\n      key: secretkey\n      name: release-name-minio\n    bucket: argo-workflows\n    endpoint: minio:9000\n    insecure: true\nmetricsConfig:\n  enabled: true\n  path: /metrics\n  port: 9090\n  ignoreErrors: false\n  secure: false\ntelemetryConfig:\n  enabled: true\n  path: /telemetry\n  port: 8081\n  ignoreErrors: false\n  secure: false\npersistence:\n  archive: true\n  connectionPool:\n    maxIdleConns: 100\n    maxOpenConns: 0\n  nodeStatusOffLoad: false\n  postgresql:\n    database: postgres\n    host: localhost\n    passwordSecret:\n      key: password\n      name: argo-postgres-config\n    port: 5432\n    ssl: true\n    sslMode: verify-full\n    tableName: argo_workflows\n    userNameSecret:\n      key: username\n      name: argo-postgres-config\nworkflowDefaults:\n  spec:\n    artifactRepositoryRef:\n      configMap: my-artifact-repository\n      key: v2-s3-artifact-repository\n    ttlStrategy:\n      secondsAfterCompletion: 86400\nsso:\n  issuer: https://dex.example.com\n  clientId:\n    name: argo-server-sso\n    key: client-id\n  clientSecret:\n    name: argo-server-sso\n    key: client-secret\n  redirectUrl: \"https://argo-workflows.example.com/oauth2/callback\"\n  rbac:\n    enabled: true\n  scopes:\n    - openid\n    - profile\n    - email\n    - groups\n  sessionExpiry: 10h\n  customGroupClaimName: groups\nsynchronization:\n  connectionPool:\n    maxIdleConns: 100\n    maxOpenConns: 0\n  controllerName: argo-workflows\n  postgresql:\n    database: postgres\n    host: localhost\n    passwordSecret:\n      key: password\n      name: argo-postgres-config\n    port: 5432\n    ssl: true\n    sslMode: verify-full\n    tableName: argo_workflows\n    userNameSecret:\n      key: username\n      name: argo-postgres-config\nworkflowRestrictions:\n  templateReferencing: Secure\nnodeEvents:\n  enabled: true\nworkflowEvents:\n  enabled: true\n"
  }
}

