#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

BASE="${1:---base}"
STRICT=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base) BASE="$2"; shift 2 ;;
    --strict) STRICT=true; shift ;;
    *) shift ;;
  esac
done

if [[ "$BASE" == "--base" ]]; then
  BASE="origin/main"
fi

WARNINGS=0

for skill_dir in skills/mk-*/; do
  [[ -d "$skill_dir" ]] || continue
  skill_file="${skill_dir}SKILL.md"
  [[ -f "$skill_file" ]] || continue

  dir_name=$(basename "$skill_dir")

  # Check if content changed
  if git diff "$BASE" -- "$skill_dir" --quiet 2>/dev/null; then
    continue
  fi

  # Extract version from current
  current_version=$(grep '^\s*version:' "$skill_file" 2>/dev/null | head -1 | sed 's/.*version:[[:space:]]*//' | tr -d '"' | tr -d "'" || true)

  # Extract version from base
  base_version=$(git show "$BASE:$skill_file" 2>/dev/null | grep '^\s*version:' | head -1 | sed 's/.*version:[[:space:]]*//' | tr -d '"' | tr -d "'" || true)

  if [[ "$current_version" == "$base_version" ]]; then
    echo -e "${YELLOW}WARN${NC} [$dir_name] Content changed but version unchanged ($current_version)"
    ((WARNINGS++))
  else
    echo -e "${GREEN}OK${NC} [$dir_name] Version bumped: $base_version -> $current_version"
  fi
done

echo ""
if [[ $WARNINGS -gt 0 ]]; then
  echo -e "${YELLOW}$WARNINGS warning(s): skills changed without version bump.${NC}"
  if $STRICT; then
    exit 1
  fi
else
  echo -e "${GREEN}All changed skills have version bumps.${NC}"
fi
