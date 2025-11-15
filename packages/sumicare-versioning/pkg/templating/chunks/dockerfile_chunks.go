//
// Copyright (c) 2025 Sumicare
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package chunks

import "strings"

// ldFlagsVariableInterpolation is the variable interpolation const for ${LD_FLAGS}.
const ldFlagsVariableInterpolation = "${LD_FLAGS}"

// goBinary represents a single binary to build.
type goBinary struct {
	Name    string
	Pkg     string
	LDFlags string
}

// normalizePkg converts package path to build command format.
func normalizePkg(name, pkg string) string {
	if pkg == "" {
		return "./cmd/" + name
	}

	if pkg == "." {
		return "-o " + name + " ."
	}

	return pkg
}

// DockerfileHeader renders the common Dockerfile header with SBOM args and FROM build.
func DockerfileHeader(debianVersion string) string {
	return `ARG BUILDKIT_SBOM_SCAN_CONTEXT=true
ARG BUILDKIT_SBOM_SCAN_STAGE=true
ARG DEBIAN_VERSION="` + debianVersion + `"
ARG REPO="docker.io/"
ARG ORG="sumicare"`
}

// DockerfileBuildHeader renders the common Dockerfile header with SBOM args and FROM build.
func DockerfileBuildHeader(name, debianVersion, version, repo string) string {
	nameUpper := strings.ReplaceAll(strings.ToUpper(name), "-", "_")

	return DockerfileHeader(debianVersion) + `
FROM ${REPO}${ORG}/build:${DEBIAN_VERSION} AS build

ARG TARGETARCH

ARG ` + nameUpper + `_VERSION="` + version + `"
ARG ` + nameUpper + `_REPO="` + repo + `"`
}

// dockerfileBuildEnv renders the build environment setup (HOMEDIR, ADD, WORKDIR).
func dockerfileBuildEnv(name, nameUpper, versionPrefix, workdir string) string {
	return `
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${` + nameUpper + `_REPO}#` + versionPrefix + `${` + nameUpper + `_VERSION} ${HOMEDIR}/` + name + `

WORKDIR ${HOMEDIR}/` + workdir
}

// dockerfileLDFlags renders the LD_FLAGS ARG.
//
//nolint:revive // it's just a template
func dockerfileLDFlags(ldflags string, isStatic bool) string {
	if isStatic {
		return `
ARG LD_FLAGS="-s -w -extldflags '-static'` + ldflags + `"`
	}

	return `
ARG LD_FLAGS="-s -w"`
}

// dockerfileVendorCacheStart renders the start of the vendor cache RUN block.
// If useAbsolutePath is true, uses ${HOMEDIR}/cached-vendor paths for multi-binary builds.
//
//nolint:revive // it's just a template
func dockerfileVendorCacheStart(name string, useAbsolutePath bool) string {
	srcPath := "cached-vendor/"
	dstPath := "cached-vendor/*"

	if useAbsolutePath {
		srcPath = "${HOMEDIR}/cached-vendor/"
		dstPath = "${HOMEDIR}/cached-vendor/*"
	}

	return `

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-vendor-${TARGETARCH},target=${HOMEDIR}/` + name + `/cached-vendor,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    [ -z "$(ls -A cached-vendor)" ] && go mod tidy && go mod vendor && cp -r vendor/* ` + srcPath + ` ; \
    [ -n "$(ls -A cached-vendor)" ] && mkdir -p vendor && cp -r ` + dstPath + ` vendor/ && go mod tidy && go mod vendor && cp -r vendor/* ` + srcPath + ` ; \
`
}

// dockerfileVendorCacheEnd renders the cleanup portion of the RUN block.
func dockerfileVendorCacheEnd() string {
	return `    go clean -cache -modcache ; \
    rm -rf vendor ; \
    rm -rf ${HOMEDIR}/.cache ; \
    rm -rf ${GOPATH}/pkg ${GOPATH}/src
`
}

// dockerfileDistrolessStage renders the distroless stage with COPY and ENTRYPOINT.
func dockerfileDistrolessStage(workdir string, binaries []goBinary) string {
	var copyStmts strings.Builder
	for i := range binaries {
		copyStmts.WriteString("COPY --chown=0:0 --from=build ${HOMEDIR}/" + workdir +
			"/" + binaries[i].Name + " /usr/bin/" + binaries[i].Name + "\n")
	}

	return `
FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

` + copyStmts.String() + `
USER nonroot

ENTRYPOINT ["/usr/bin/` + binaries[0].Name + `"]`
}

// DockerfileGoBinary renders common build chunk for a single Go binary.
func DockerfileGoBinary(name, debianVersion, version, repo, ldflags, versionPrefix, workdir, pkg string) string {
	nameUpper := strings.ReplaceAll(strings.ToUpper(name), "-", "_")

	prefix := versionPrefix
	if prefix == "" {
		prefix = "v"
	}

	wd := workdir
	if wd == "" {
		wd = name
	}

	pkgToBuild := normalizePkg(name, pkg)

	buildCmd := "    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags=\"" + ldFlagsVariableInterpolation + "\" -v " + pkgToBuild + " ; \\\n"
	packCmd := "    upx --best --lzma --exact " + name + " ; \\\n"

	binaries := []goBinary{{Name: name, Pkg: pkgToBuild, LDFlags: ldflags}}

	return DockerfileBuildHeader(name, debianVersion, version, repo) +
		dockerfileBuildEnv(name, nameUpper, prefix, wd) +
		dockerfileLDFlags(ldflags, true) +
		dockerfileVendorCacheStart(name, false) +
		buildCmd + packCmd +
		dockerfileVendorCacheEnd() +
		dockerfileDistrolessStage(wd, binaries)
}

// parseBinarySpec parses a "name--pkg--ldflags" string into a goBinary.
func parseBinarySpec(spec string) (goBinary, bool) {
	const (
		minParts   = 2
		ldFlagsIdx = 2
	)

	parts := strings.Split(spec, "--")
	if len(parts) < minParts {
		return goBinary{}, false
	}

	name, pkg := parts[0], parts[1]
	ldflags := ldFlagsVariableInterpolation

	if len(parts) > ldFlagsIdx && parts[ldFlagsIdx] != "" {
		ldflags = ldFlagsVariableInterpolation + " " + parts[ldFlagsIdx]
	}

	return goBinary{
		Name:    name,
		Pkg:     normalizePkg(name, pkg),
		LDFlags: ldflags,
	}, true
}

// hasCustomLDFlags checks if any binary has custom ldflags.
func hasCustomLDFlags(binaries []goBinary) bool {
	for i := range binaries {
		if binaries[i].LDFlags != ldFlagsVariableInterpolation {
			return true
		}
	}

	return false
}

// buildMultiBinaryCommands generates build and pack commands for multiple binaries.
func buildMultiBinaryCommands(binaries []goBinary) (string, string) {
	var build, pack strings.Builder

	for i := range binaries {
		build.WriteString("    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor " +
			"-ldflags=\"" + binaries[i].LDFlags + "\" -v -o " + binaries[i].Name + " " + binaries[i].Pkg + " ; \\\n")
		pack.WriteString("    upx --best --lzma --exact " + binaries[i].Name + " ; \\\n")
	}

	return build.String(), pack.String()
}

// DockerfileGoBinaries renders common chunk for multiple binaries from a single repo.
// namePkgLDFlags is a set of "name--pkg--ldflags" strings.
func DockerfileGoBinaries(name, debianVersion, version, repo, versionPrefix, workdir string, namePkgLDFlags ...string) string {
	binaries := make([]goBinary, 0, len(namePkgLDFlags))

	for _, spec := range namePkgLDFlags {
		if bin, ok := parseBinarySpec(spec); ok {
			binaries = append(binaries, bin)
		}
	}

	if len(binaries) == 0 {
		return ""
	}

	nameUpper := strings.ReplaceAll(strings.ToUpper(name), "-", "_")

	prefix := versionPrefix
	if prefix == "" {
		prefix = "v"
	}

	wd := workdir
	if wd == "" {
		wd = name
	}

	return DockerfileBuildHeader(name, debianVersion, version, repo) +
		dockerfileBuildEnv(name, nameUpper, prefix, wd) + "\n\n" +
		DockerfileBuildGoBinaries(name, wd, namePkgLDFlags...)
}

// DockerfileBuildGoBinaries renders common chunk for multiple binaries from a single repo.
func DockerfileBuildGoBinaries(name, workdir string, namePkgLDFlags ...string) string {
	binaries := make([]goBinary, 0, len(namePkgLDFlags))

	for _, spec := range namePkgLDFlags {
		if bin, ok := parseBinarySpec(spec); ok {
			binaries = append(binaries, bin)
		}
	}

	if len(binaries) == 0 {
		return ""
	}

	useStaticLDFlags := !hasCustomLDFlags(binaries)
	buildStmts, packStmts := buildMultiBinaryCommands(binaries)

	return dockerfileLDFlags("", useStaticLDFlags) +
		dockerfileVendorCacheStart(name, true) +
		buildStmts + packStmts +
		dockerfileVendorCacheEnd() +
		dockerfileDistrolessStage(workdir, binaries)
}

// DockerfileDistrolessUnpack returns common Debian distroless dockerfile unpack chunk.
func DockerfileDistrolessUnpack() string {
	return `RUN --mount=type=cache,id=cache-apt-${TARGETARCH},target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=lib-apt-${TARGETARCH},target=/var/lib/apt,sharing=locked \
    set -eux ; \
    # Download and extract packages
    apt-get update -y ; \
    apt-get upgrade -y ; \
    echo ${DISTROLESS_PACKAGES} | xargs apt-get download -y --no-install-recommends --no-install-suggests ; \
    mkdir -p /dpkg/var/lib/dpkg/status.d/ ; \
    for deb in *.deb; do \
    package_name="$(dpkg-deb -I "${deb}" | awk '/^ Package: .*$/ {print $2}')" ; \
    echo "Processing: ${package_name}" ; \
    dpkg --ctrl-tarfile "$deb" | tar -Oxf - ./control > "/dpkg/var/lib/dpkg/status.d/${package_name}" ; \
    dpkg --extract "$deb" /dpkg || exit 10 ; \
    done ; \
    # Cleanup
    find /dpkg/ -type d -empty -delete ; \
    rm -rf /dpkg/usr/share/doc/ ; \
    apt-get purge -y --auto-remove ; \
    find /usr -name '*.pyc' -type f -exec bash -c 'for pyc; do dpkg -S "$pyc" &> /dev/null || rm -vf "$pyc"; done' -- '{}' + ; \
    rm -rf /var/lib/apt/lists/* `
}
