#!/usr/bin/env bash
set -euo pipefail

# Keeps track of installed asdf tools and binaries availability

# Color codes for output
RED='\033[0;31m'
NC='\033[0m' # No Color

# Binary name overrides
declare -A overrides=([golang]=go [nodejs]="node" [github - cli]=gh [awscli]=aws [opentofu]=tofu)

# Check tools from .tool-versions
while read -r line; do
  [[ "$line" =~ ^[[:space:]]*# || -z "${line// /}" ]] && continue
  tool=$(echo "$line" | awk '{print $1}')
  binary=${overrides[$tool]:-$tool}
  command -v "$binary" &>/dev/null || echo -e "${RED}✗${NC} $tool: $binary not found"
done <.tool-versions
