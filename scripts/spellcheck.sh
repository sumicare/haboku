#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

cd ..

trap 'rm -f ".cspell-temp-config.json"' EXIT

WORDS_ARRAY=$(sed -n '/"cSpell.words": \[/,/\]/p' "sumicare-kubernetes.code-workspace" | sed 's/"cSpell.words": //' | sed 's/],$/]/')
if [ -z "${WORDS_ARRAY}" ]; then
  WORDS_ARRAY="[]"
fi

cat >".cspell-temp-config.json" <<EOF
{
  "version": "0.2",
  "language": "en",
  "words": ${WORDS_ARRAY},
  "languageSettings": [
    {
      "languageId": "*",
      "allowCompoundWords": false,
      "dictionaries": ["en", "en-US", "en-GB", "companies", "softwareTerms", "misc"]
    }
  ],
  "ignorePaths": [
    "node_modules/**",
    "legacy/**",
    ".git/**",
    ".yarn/**",
    "*.lock",
    "yarn.lock",
    "package-lock.json",
    "go.mod",
    "go.sum",
    "go.work.sum",
    "*.min.*",
    ".terraform/**",
    "*.tfstate*",
    "*.log",
    "**/coverage/**",
    "**/build/**",
    "**/dist/**",
    "**/crds/*.yaml",
  ],
  "ignoreRegExpList": [
    "/[А-Яа-яЁёІіЇїЄєҐґ]+/g",
    "/[\\u0400-\\u04FF]+/g"
  ]
}
EOF

yarn cspell --config=.cspell-temp-config.json --no-progress --show-context --cache --cache-location .cspell-cache "./**" "$@"
