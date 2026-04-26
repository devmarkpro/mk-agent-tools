#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0
ALLOWED_TOP_FIELDS="name|description|license|compatibility|allowed-tools|metadata|argument-hint|disable-model-invocation|user-invocable|paths|context|agent|model|effort|hooks|shell"
PREFIX="dmp-"

lint_skill() {
  local file="$1"
  local dir_name
  dir_name=$(basename "$(dirname "$file")")
  local line_count
  line_count=$(wc -l < "$file")

  # Check frontmatter delimiters
  local first_line
  first_line=$(head -1 "$file")
  if [[ "$first_line" != "---" ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] Missing opening frontmatter delimiter"
    ((ERRORS++))
    return
  fi

  local second_delim
  second_delim=$(tail -n +2 "$file" | grep -n "^---$" | head -1 | cut -d: -f1)
  if [[ -z "$second_delim" ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] Missing closing frontmatter delimiter"
    ((ERRORS++))
    return
  fi

  # Extract frontmatter
  local fm
  fm=$(sed -n "2,$((second_delim))p" "$file")

  # Check name field
  local name
  name=$(echo "$fm" | grep "^name:" | head -1 | sed 's/^name:[[:space:]]*//')
  if [[ -z "$name" ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] Missing 'name' field"
    ((ERRORS++))
  elif [[ "$name" != "$dir_name" ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] name '$name' does not match directory '$dir_name'"
    ((ERRORS++))
  elif [[ ! "$name" =~ ^${PREFIX} ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] name must start with '${PREFIX}'"
    ((ERRORS++))
  elif [[ ${#name} -gt 64 ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] name exceeds 64 characters"
    ((ERRORS++))
  elif [[ "$name" =~ -- ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] name contains consecutive hyphens"
    ((ERRORS++))
  elif [[ ! "$name" =~ ^[a-z0-9][a-z0-9-]*[a-z0-9]$ ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] name must be lowercase alphanumeric with hyphens"
    ((ERRORS++))
  fi

  # Check description
  local desc
  desc=$(echo "$fm" | grep "^description:" | head -1 | sed 's/^description:[[:space:]]*//')
  if [[ -z "$desc" ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] Missing 'description' field"
    ((ERRORS++))
  elif [[ ${#desc} -gt 1024 ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] description exceeds 1024 characters"
    ((ERRORS++))
  fi

  # Check tags
  local has_tags
  has_tags=$(echo "$fm" | grep -c "^  tags:" || true)
  if [[ "$has_tags" -eq 0 ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] Missing metadata.tags"
    ((ERRORS++))
  else
    local tag_count
    tag_count=$(echo "$fm" | grep "^    - " | wc -l | tr -d ' ')
    if [[ "$tag_count" -eq 0 ]]; then
      echo -e "${RED}FAIL${NC} [$dir_name] metadata.tags must have at least one entry"
      ((ERRORS++))
    fi
  fi

  # Check version semver (if present)
  local version
  version=$(echo "$fm" | grep '^\s*version:' | head -1 | sed 's/.*version:[[:space:]]*//' | tr -d '"' | tr -d "'")
  if [[ -n "$version" ]] && [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] version '$version' is not valid semver"
    ((ERRORS++))
  fi

  # Check top-level fields
  local bad_fields
  bad_fields=$(echo "$fm" | grep -E "^[a-z]" | grep -v -E "^(${ALLOWED_TOP_FIELDS}):" || true)
  if [[ -n "$bad_fields" ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] Disallowed top-level fields: $(echo "$bad_fields" | cut -d: -f1 | tr '\n' ' ')"
    ((ERRORS++))
  fi

  # Check line count
  if [[ "$line_count" -ge 500 ]]; then
    echo -e "${RED}FAIL${NC} [$dir_name] SKILL.md is $line_count lines (max 500)"
    ((ERRORS++))
  fi

  if [[ $ERRORS -eq 0 ]]; then
    echo -e "${GREEN}PASS${NC} [$dir_name]"
  fi
}

# Find skills to lint
if [[ $# -gt 0 ]]; then
  files=("$@")
else
  files=()
  while IFS= read -r -d '' f; do
    files+=("$f")
  done < <(find skills -name "SKILL.md" -print0 2>/dev/null)
fi

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No SKILL.md files found."
  exit 0
fi

# Check for duplicate names
declare -A seen_names
for file in "${files[@]}"; do
  dir_name=$(basename "$(dirname "$file")")
  if [[ -n "${seen_names[$dir_name]:-}" ]]; then
    echo -e "${RED}FAIL${NC} Duplicate skill name: $dir_name"
    ((ERRORS++))
  fi
  seen_names[$dir_name]=1
done

for file in "${files[@]}"; do
  lint_skill "$file"
done

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo -e "${RED}$ERRORS error(s) found.${NC}"
  exit 1
else
  echo -e "${GREEN}All skills passed validation.${NC}"
fi
