## Референсна Хмарно-Нативна Архітектура

[English](../RCNA.md)

Референсна Хмарно-Нативна Архітектура (RCNA) — це курований набір зрілих CNCF проєктів, призначених для забезпечення надійної, 
економічно ефективної та безпечної основи для запуску сучасних хмарно-нативних застосунків.

Вона наголошує на:
- Чітко визначених найкращих практиках
- Повній спостережуваності
- Усуненні циклічних залежностей у безперервних розгортаннях та безперервному провізіонінгу
- Безстанній інфраструктурі
- Економічно свідомому провізіонінгу та предиктивному автомасштабуванні
- Передбачуваній вартості володіння
- Вендорній нейтральності

## RCNA складається з 

- **Базові Образи** — безпечні контейнерні основи

  [Debian](https://www.debian.org/) надає мінімальні, безпечні базові образи.

- **Площина Розробки** — CI/CD, управління артефактами та ідентифікація

  [Tekton Pipeline](https://github.com/tektoncd/pipeline) надає Kubernetes-нативні будівельні блоки CI/CD.
  
  [Tekton Triggers](https://github.com/tektoncd/triggers) забезпечує виконання пайплайнів через вебхуки.
  
  [Tekton Chains](https://github.com/tektoncd/chains) підписує артефакти та генерує SLSA провенанс.
  
  [Tekton Results](https://github.com/tektoncd/results) зберігає історію пайплайнів у зовнішніх бекендах.
  
  [Tekton Dashboard](https://github.com/tektoncd/dashboard) надає візуалізацію пайплайнів.
  
  [Atlas Operator](https://github.com/ariga/atlas-operator) керує декларативними міграціями баз даних.

  [Dex](https://github.com/dexidp/dex) федерує провайдерів ідентифікації в уніфікований OIDC.

  [Gitea](https://github.com/go-gitea/gitea) надає легкий self-hosted Git сервіс.

- **Площина GitOps** — декларативна доставка та автоматизація воркфлоу

  [Argo CD](https://github.com/argoproj/argo-cd) узгоджує стан кластера з Git репозиторіями.

  [Argo Rollouts](https://github.com/argoproj/argo-rollouts) забезпечує прогресивну доставку.

  [Argo Workflows](https://github.com/argoproj/argo-workflows) оркеструє складні DAG завдань.

  [Argo Events](https://github.com/argoproj/argo-events) з'єднує джерела подій з тригерами.

- **Площина MLOps** — розподілені обчислення та обслуговування моделей

  [Volcano](https://github.com/volcano-sh/volcano) надає gang scheduling для ML навантажень.

  [KubeRay](https://github.com/ray-project/kuberay) керує Ray кластерами на Kubernetes.

  [DataFusion Ballista](https://github.com/apache/datafusion-ballista) надає розподілений SQL.

  [OME](https://github.com/sgl-project/ome) обслуговує LLM з оптимізованим інференсом.

- **Площина Мережі** — CNI, service mesh та управління трафіком

  [Calico](https://github.com/projectcalico/calico) надає CNI з примусовим виконанням мережевих політик.

  [Gateway API](https://github.com/kubernetes-sigs/gateway-api) замінює Ingress з виразною маршрутизацією.

  [Linkerd](https://linkerd.io/) надає легкий service mesh з автоматичним mTLS.

  [External DNS](https://github.com/kubernetes-sigs/external-dns) автоматизує управління DNS записами.

- **Площина Спостережуваності** — метрики, логи, трейси та профілі

  [Prometheus](https://github.com/prometheus/prometheus) надає pull-based збір метрик.

  [Mimir](https://github.com/grafana/mimir) масштабує Prometheus до необмеженої кардинальності.

  [Loki](https://github.com/grafana/loki) надає економічно ефективну агрегацію логів.

  [Tempo](https://github.com/grafana/tempo) зберігає трейси без індексації.

  [Pyroscope](https://github.com/grafana/pyroscope) забезпечує безперервне профілювання.

  [Grafana](https://github.com/grafana/grafana) уніфікує візуалізацію спостережуваності.

  [Grafana Alloy](https://github.com/grafana/alloy) збирає всі телеметричні сигнали.

  [Grafana MCP](https://github.com/grafana/mcp-grafana) забезпечує AI-асистовану спостережуваність.

- **Площина Безпеки** — секрети, сертифікати, політики та захист під час виконання

  [cert-manager](https://github.com/cert-manager/cert-manager) автоматизує життєвий цикл TLS сертифікатів.

  [Bank-Vaults Operator](https://github.com/bank-vaults/vault-operator) керує Vault/[OpenBao](https://github.com/openbao/openbao) кластерами.

  [Bank-Vaults Webhook](https://github.com/bank-vaults/secrets-webhook) інжектує секрети Vault.

  [OpenBao](https://github.com/openbao/openbao) надає open-source управління секретами (форк Vault).

  [OpenFGA](https://github.com/openfga/openfga) надає fine-grained авторизацію.

  [Reloader](https://github.com/stakater/Reloader) тригерить rollout при змінах ConfigMap/Secret.

  [Kyverno](https://github.com/kyverno/kyverno) примусово виконує політики як Kubernetes CRD.
 
  [Falco](https://github.com/falcosecurity/falco) виявляє загрози під час виконання через аналіз syscall.

- **Площина Сховища** — персистентне сховище, об'єктне сховище та системи даних

  [Local Path Provisioner](https://github.com/rancher/local-path-provisioner) забезпечує node-local PVC.

  [TopoLVM](https://github.com/topolvm/topolvm) надає LVM-based локальне сховище з плануванням.

  [PVC Autoresizer](https://github.com/topolvm/pvc-autoresizer) автоматично розширює томи.

  [Velero](https://github.com/vmware-tanzu/velero) надає резервне копіювання та аварійне відновлення.

  [CloudNativePG](https://github.com/cloudnative-pg/cloudnative-pg) оперує PostgreSQL кластерами.

  [Valkey](https://github.com/valkey-io/valkey) надає Redis-сумісне in-memory сховище (форк Redis).
