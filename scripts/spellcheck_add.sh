#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.." || exit 1

trap 'rm -f "sumicare-kubernetes.code-workspace.new" || true' EXIT

# Extract new words and check if any exist
new_words=$("$(dirname "$0")/spellcheck.sh" 2>&1 | sed -nE 's/.*- Unknown word \(([a-zA-Z0-9._-]+)\).*/\L\1/p' | sort -u || true)
[ -z "$new_words" ] && exit 0

# Merge existing and new words, format as JSON
formatted_words=$({
  sed -nE '/"cSpell.words": \[/,/\]/{s/^\s*"([a-zA-Z0-9._-]+)".*/\L\1/p}' "sumicare-kubernetes.code-workspace" 2>/dev/null || true
  echo "$new_words"
} | sort -u | sed 's/.*/"&",/' | sed '$ s/,$//')

# Update workspace file in place
{
  awk '/"cSpell\.words": \[/,/\]/ {
		if (/"cSpell\.words": \[/) {
			print "    \"cSpell.words\": ["
			print words
			next
		}
		if (/\]/) {
			print "    ],"
			next
		}
		next
	}
	{ print }' words="      ${formatted_words//$'\n'/$'\n      '}" "sumicare-kubernetes.code-workspace"
} >"sumicare-kubernetes.code-workspace.new" &&
  mv "sumicare-kubernetes.code-workspace.new" "sumicare-kubernetes.code-workspace"
