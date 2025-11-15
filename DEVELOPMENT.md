### Local Development 🛠️

To work locally, first build the Docker images:
```bash
cd ./packages/debian/modules/sumicare-images 
tofu init
tofu apply
# or
ginkgo run -v .
```
Image dependencies and build parallelization are managed by the [sumicare-images](./packages/debian/modules/sumicare-images) Terraform module.

Common helper commands:
```bash
yarn build               # - to build respective projects, whenever applicable
yarn commit              # - to run commitizen
yarn format              # - to run various code formatters
yarn lint                # - to run lint
yarn spellcheck          # - to run spellcheck
yarn spellcheck:add      # - to add new words to spellcheck dictionary in `.code-workspace` file
yarn test                # - to run tests
yarn update:versions     # - to update images versions dependencies
yarn update:versions:go  # - to update all golang dependencies inside the workspace
yarn update:snapshots    # - to update testing golden files and various snapshots

yarn upgrade-interactive # - use stock yarn plugin to update node.js deps
```

### ASDF is a Valid Attack Vector ⚠️

Sumicare greatly discourage using ASDF for production builds, without proper [slsa.dev](https://slsa.dev/) provenance, and version locking all asdf plugins.
Asdf plugins are **valid attack vector** for supply chain attacks.

Please, manually version lock your ASDF plugins and associated dependencies, ensure your teams are trained to provide Viable Container Image Provenance.

We're planning to provide a standalone ASDF plugin that will download all the commonly used tools and dependencies, without relying on any bash scripting.
It's not like we're against scripting, it's just the maintenance overhead outweighs the benefit.

### Artifact Management

The devcontainer uses a different build setup, so prefer running builds on your local environment to avoid duplicating large images and wasting disk space.
We **DON'T** push local base/build images (17GB+).

All binaries are packed with UPX (lzma), reducing size by about 80%.
Startup slows down by roughly half a second, which is acceptable for our use.

The Terraform [docker provider](https://github.com/kreuzwerker/terraform-provider-docker/issues/826) currently does not support automated Docker SBOM management or in-toto attestations.

You can wrap the [sumicare-images](./packages/debian/modules/sumicare-images) module for stateful image management and integrate it into a CI/CD workflow for air-gapped preparation and distribution.

### Simple Local Development Setup

The [Devcontainer Dockerfile](./Dockerfile.devcontainer) is intentionally dense and uses newer Dockerfile features, so here is a brief explanation.

The gist is:

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

# Check bins availability with
./packages/debian/modules/debian-images/scripts/which.sh
```

This installs `python` and `golang` first because other tools depend on them.

### Line by Line

1. We're [adding initial args](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/Dockerfile.devcontainer#L4C1-L5C34) to enable BuildKit provenance and SBOM collection

```dockerfile
ARG BUILDKIT_SBOM_SCAN_CONTEXT=true
ARG BUILDKIT_SBOM_SCAN_STAGE=true
```
 
2. We are ["deslimifying"](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/Dockerfile.devcontainer#L30) the Debian Slim image by adding locales, tzdata, build-essential, CA certificates, and other common build tools.
`TARGETARCH` is not set automatically in Docker 20+, so we pass it explicitly and use it to key the arch-specific buildx cache for multi-arch builds.

```dockerfile
ARG DEBIAN_VERSION="trixie-20251117-slim"

FROM debian:${DEBIAN_VERSION} AS base

ARG TARGETARCH

#...

RUN apt-get install -y build-essential bash zsh git curl unzip openssl ca-certificates locales tzdata tar gpg python3 python3-pip 
```

3. We set and reconfigure locales, then enable APT caching to reuse the same arch-specific [RUN --mount=type=cache](https://docs.docker.com/build/cache/optimize/#use-cache-mounts) paths for faster builds (the official docs understate this pattern).
We use `en_US` only for the devcontainer; for other builds we use `C.UTF8` to avoid running `locale-gen` in distroless images.

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

4. It's essential to [clean up python](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/Dockerfile.devcontainer#L49) compiled `pyc` files to shrink down the layer a bit, and remove apt lists

```dockerfile    
RUN apt-get purge -y --auto-remove ; \
    find /usr -name '*.pyc' -type f -exec bash -c 'for pyc; do dpkg -S "$pyc" &> /dev/null || rm -vf "$pyc"; done' -- '{}' + ; \
    rm -rf /var/lib/apt/lists/*
```

5. We use [sudo](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/Dockerfile.devcontainer#L63) in the devcontainer image for flexibility, but production images must not contain any SUID/SGID binaries.

```dockerfile
RUN useradd --shell /bin/zsh -l -m -d ${HOMEDIR} -u ${UID} -g ${GID} developer ; \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/developer ; \
    chmod 0440 /etc/sudoers.d/developer
```

6. We need a standalone Go installation to bootstrap ASDF, so we are [downloading a recent](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/Dockerfile.devcontainer#L76) Go binary release. Matching the `.tool-versions` Go version is recommended but not mandatory.

```dockerfile
ARG GOLANG_VERSION="1.25.4"
RUN curl -sSLo go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz https://go.dev/dl/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz 
```

7. We copy the `asdf` directory and expect it to contain version-locked **asdf plugins**, with `.gitkeep` removed to indicate that it is populated. `asdf plugin install` then works both for bundled plugins and official ones.

```dockerfile
RUN [ ! -f "${HOMEDIR}/.asdf/plugins/.gitkeep" ] && asdf plugin add python ${HOMEDIR}/.asdf/plugins/python && asdf plugin add golang ${HOMEDIR}/.asdf/plugins/golang ; \
    [ -f "${HOMEDIR}/.asdf/plugins/.gitkeep" ] && asdf plugin add python && asdf plugin add golang ; \
```

8. We install Python and Go first because they are prerequisites for Ariga Atlas, `gcloud`, and Checkov.

9. We install Yarn with [corepack](https://www.npmjs.com/package/corepack?activeTab=readme), without relying on ASDF, to keep the setup simple and aligned with common Node.js practice.

10. Distroless images [apt-get download](https://github.com/sumicare/terraform-kubernetes-modules/blob/master/packages/debian/modules/debian-images/Dockerfile.distroless#L21) all required packages and include them in the final image, with build dependencies kept separate for each image.

This may look complex, but it reflects standard practices for our environment.