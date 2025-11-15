### Локальна Розробка 🛠️

[English](../DEVELOPMENT.md)

Для локальної роботи спочатку зберіть Docker образи:
```bash
cd ./packages/debian/modules/sumicare-images 
tofu init
tofu apply
# або
ginkgo run -v .
```
Залежності образів та паралелізація збірки керуються Terraform модулем [sumicare-images](./packages/debian/modules/sumicare-images).

Загальні допоміжні команди:
```bash
yarn build               # - для збірки відповідних проєктів, де це застосовно
yarn commit              # - для запуску commitizen
yarn format              # - для запуску різних форматерів коду
yarn lint                # - для запуску лінтера
yarn spellcheck          # - для запуску перевірки орфографії
yarn spellcheck:add      # - для додавання нових слів до словника у файлі `.code-workspace`
yarn test                # - для запуску тестів
yarn update:versions     # - для оновлення залежностей версій образів
yarn update:versions:go  # - для оновлення всіх golang залежностей у воркспейсі
yarn update:snapshots    # - для оновлення golden файлів тестування та різних снепшотів

yarn upgrade-interactive # - використовуйте стандартний yarn плагін для оновлення node.js залежностей
```

### ASDF є Валідним Вектором Атаки ⚠️

Sumicare наполегливо не рекомендує використовувати ASDF для продакшн збірок без належного [slsa.dev](https://slsa.dev/) провенансу та фіксації версій усіх asdf плагінів.
Asdf плагіни є **валідним вектором атаки** для атак на ланцюг постачання.

Будь ласка, вручну фіксуйте версії ваших ASDF плагінів та пов'язаних залежностей, переконайтеся, що ваші команди навчені забезпечувати Життєздатний Провенанс Контейнерних Образів.

Ми плануємо надати окремий ASDF плагін, який завантажуватиме всі часто використовувані інструменти та залежності без покладання на bash скрипти.
Це не означає, що ми проти скриптів, просто накладні витрати на підтримку переважують користь.

### Управління Артефактами

Devcontainer використовує інше налаштування збірки, тому віддавайте перевагу запуску збірок у вашому локальному середовищі, щоб уникнути дублювання великих образів та марнування дискового простору.
Ми **НЕ** пушимо локальні base/build образи (17GB+).

Усі бінарні файли запаковані за допомогою UPX (lzma), що зменшує розмір приблизно на 80%.
Запуск сповільнюється приблизно на півсекунди, що прийнятно для нашого використання.

Terraform [docker provider](https://github.com/kreuzwerker/terraform-provider-docker/issues/826) наразі не підтримує автоматизоване управління Docker SBOM або in-toto атестації.

Ви можете обгорнути модуль [sumicare-images](./packages/debian/modules/sumicare-images) для stateful управління образами та інтегрувати його в CI/CD воркфлоу для підготовки та розповсюдження в ізольованих середовищах.

### Просте Налаштування Локальної Розробки

[Devcontainer Dockerfile](./Dockerfile.devcontainer) навмисно щільний та використовує новіші функції Dockerfile, тому ось коротке пояснення.

Суть така:

```bash
asdf plugin add python
asdf plugin add golang
asdf install python 
asdf install golang 
cat .tool-versions | grep -v '^#' | cut -d " " -f 1 | xargs -r -I {} asdf plugin add {}
asdf install 

npm install -g corepack
npm install --force -g yarn 
corepack enable
corepack install -g yarn
asdf reshim

# Перевірте доступність бінарних файлів за допомогою
./packages/debian/modules/debian-images/scripts/which.sh
```

Це встановлює `python` та `golang` першими, оскільки інші інструменти залежать від них.

### Порядково

1. Ми [додаємо початкові аргументи](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/Dockerfile.devcontainer#L4C1-L5C34) для увімкнення BuildKit провенансу та збору SBOM

```dockerfile
ARG BUILDKIT_SBOM_SCAN_CONTEXT=true
ARG BUILDKIT_SBOM_SCAN_STAGE=true
```
 
2. Ми ["розслімлюємо"](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/Dockerfile.devcontainer#L30) Debian Slim образ, додаючи locales, tzdata, build-essential, CA сертифікати та інші загальні інструменти збірки.
`TARGETARCH` не встановлюється автоматично в Docker 20+, тому ми передаємо його явно та використовуємо для ключування arch-специфічного buildx кешу для мульти-arch збірок.

```dockerfile
ARG DEBIAN_VERSION="trixie-20251117-slim"

FROM debian:${DEBIAN_VERSION} AS base

ARG TARGETARCH

#...

RUN apt-get install -y build-essential bash zsh git curl unzip openssl ca-certificates locales tzdata tar gpg python3 python3-pip 
```

3. Ми встановлюємо та переналаштовуємо локалі, потім вмикаємо APT кешування для повторного використання тих самих arch-специфічних шляхів [RUN --mount=type=cache](https://docs.docker.com/build/cache/optimize/#use-cache-mounts) для швидших збірок (офіційна документація недооцінює цей патерн).
Ми використовуємо `en_US` тільки для devcontainer; для інших збірок ми використовуємо `C.UTF8`, щоб уникнути запуску `locale-gen` у distroless образах.

```dockerfile
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US' \
    LC_ALL='en_US.UTF-8' \
    TZ='UTC' \
    DEBIAN_FRONTEND=noninteractive

RUN rm -f /etc/apt/apt.conf.d/docker-clean ; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

# ...

RUN --mount=type=cache,id=cache-apt-${TARGETARCH},target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=lib-apt-${TARGETARCH},target=/var/lib/apt,sharing=locked 
```

4. Важливо [очистити python](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/Dockerfile.devcontainer#L49) скомпільовані `pyc` файли, щоб трохи зменшити шар, та видалити apt списки

```dockerfile    
RUN apt-get purge -y --auto-remove ; \
    find /usr -name '*.pyc' -type f -exec bash -c 'for pyc; do dpkg -S "$pyc" &> /dev/null || rm -vf "$pyc"; done' -- '{}' + ; \
    rm -rf /var/lib/apt/lists/*
```

5. Ми використовуємо [sudo](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/Dockerfile.devcontainer#L63) у devcontainer образі для гнучкості, але продакшн образи не повинні містити жодних SUID/SGID бінарних файлів.

```dockerfile
RUN useradd --shell /bin/zsh -l -m -d ${HOMEDIR} -u ${UID} -g ${GID} developer ; \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/developer ; \
    chmod 0440 /etc/sudoers.d/developer
```

6. Нам потрібна окрема Go інсталяція для бутстрапу ASDF, тому ми [завантажуємо свіжий](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/Dockerfile.devcontainer#L76) Go бінарний реліз. Відповідність версії Go з `.tool-versions` рекомендована, але не обов'язкова.

```dockerfile
ARG GOLANG_VERSION="1.25.4"
RUN curl -sSLo go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz https://go.dev/dl/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz 
```

7. Ми копіюємо директорію `asdf` та очікуємо, що вона містить версійно-зафіксовані **asdf плагіни**, з видаленим `.gitkeep` для індикації, що вона заповнена. `asdf plugin install` тоді працює як для включених плагінів, так і для офіційних.

```dockerfile
RUN [ ! -f "${HOMEDIR}/.asdf/plugins/.gitkeep" ] && asdf plugin add python ${HOMEDIR}/.asdf/plugins/python && asdf plugin add golang ${HOMEDIR}/.asdf/plugins/golang ; \
    [ -f "${HOMEDIR}/.asdf/plugins/.gitkeep" ] && asdf plugin add python && asdf plugin add golang ; \
```

8. Ми встановлюємо Python та Go першими, оскільки вони є передумовами для Ariga Atlas, `gcloud` та Checkov.

9. Ми встановлюємо Yarn за допомогою [corepack](https://www.npmjs.com/package/corepack?activeTab=readme), без покладання на ASDF, щоб зберегти налаштування простим та узгодженим із загальноприйнятою практикою Node.js.

10. Distroless образи [apt-get download](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/packages/debian/modules/debian-images/Dockerfile.distroless#L21) завантажують усі необхідні пакети та включають їх у фінальний образ, з окремими залежностями збірки для кожного образу.

Це може виглядати складно, але відображає стандартні практики для нашого середовища.