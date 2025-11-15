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


locals {
  app_name = "dex"

  labels = {
    "app.kubernetes.io/instance" = "${var.org}-${var.env}"
    "app.kubernetes.io/part-of"  = local.app_name
    "app.kubernetes.io/version"  = var.dex_version
    "app.kubernetes.io/org"      = var.org
    "app.kubernetes.io/env"      = var.env
  }

  selector_labels = merge(local.labels, {
    "app.kubernetes.io/name"      = "${var.org}-${var.env}-${local.app_name}"
    "app.kubernetes.io/component" = "idp-server"
  })
}
