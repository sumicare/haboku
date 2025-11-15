# syntax=docker/dockerfile:1
# escape=\

#
# Copyright 2025 Sumicare
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

{{ GeneratedComment }}

{{ DockerfileGoBinaries 
"calico"
"networking-calico"

""
""

"../flexvol--./pod2daemon/flexvol/flexvoldriver.go--"
"../key-cert-provisioner--./key-cert-provisioner/cmd/main.go--"
"../calicoctl--./calicoctl/calicoctl/calicoctl.go--"
"../cni-install--./cni-plugin/cmd/install--"
"../cni-calico--./cni-plugin/cmd/calico--"
"../apiserver--./apiserver/cmd/apiserver--"
"../kube-controllers--./kube-controllers/cmd/kube-controllers--"
"../kube-controllers-wrapper--./kube-controllers/cmd/wrapper--"
"../check-status--./kube-controllers/cmd/check-status--"
"../dikastes--./app-policy/cmd/dikastes--"
"../healthz--./app-policy/cmd/healthz--"
"../typha--./typha/cmd/calico-typha--"
"../typha-client--./typha/cmd/typha-client--"
"../calico-node--./node/cmd/calico-node/main.go--"
"../mountns--./node/cmd/mountns--"
}}