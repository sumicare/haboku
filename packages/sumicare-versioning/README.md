## Sumicare Versioning CLI

Simple Golang CLI that

 - updates versions in the root [versions.json](../../versions.json) file
 - and adsf [.tool-versions](../../.tool-versions) files, for both root and debian build images [Build .tool-versions](../debian/modules/debian-images/.tool-versions)
 - renders all `.tpl` files with common chunks and versions
 - downloads versioned CRDs, or partially renders CRDs from existing helm charts, without any helm
 - automatically cleans up existing CRD files before downloading to ensure a fresh state

### Usage

```bash
export GITHUB_TOKEN=your_github_token_here

yarn update:versions
yarn generate
```

### GitHub Token Authentication

When downloading CRDs from GitHub repositories, you may encounter rate limiting issues. To avoid this, you can set a GitHub personal access token in the `GITHUB_TOKEN` environment variable:

To create a GitHub token:
1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate a new token with `repo:public_repo` scope (read-only access to public repositories)
3. Export the token as shown above before running the command

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE), because why not.
