# Contributing

## Skill Structure

Each skill lives in its own directory under `skills/`:

```
skills/dmp-my-skill/
├── SKILL.md            # Required: main skill file (<500 lines)
└── references/         # Optional: supporting documentation
    └── guide.md
```

## SKILL.md Format

### Required Frontmatter

```yaml
---
name: dmp-my-skill
description: Clear one-line summary (max 1024 chars)
metadata:
  tags:
    - tag-one
    - tag-two
  author: devmarkpro
  version: "1.0.0"
---
```

### Allowed Top-Level Fields

Only these top-level fields are permitted in frontmatter:

- `name` — must match directory name, start with `dmp-`, max 64 chars
- `description` — non-empty, max 1024 chars
- `metadata` — container for tags, author, version
- `license` — optional license reference
- `compatibility` — optional environment requirements (max 500 chars)
- `allowed-tools` — optional space-delimited tool list

### Content Structure

```markdown
# Skill Title

Brief overview.

## When to Use
- Trigger conditions

## When NOT to Use
- Non-trigger conditions

## [Skill-specific sections]

## Examples

### Triggering prompt
> User prompt that should invoke this skill

### Non-triggering prompt
> User prompt that should NOT invoke this skill
```

## Validation Rules

CI enforces these checks (run locally with `./scripts/lint-skills.sh`):

1. Frontmatter delimiters (`---`) present
2. `name` and `description` non-empty
3. `name` starts with `dmp-`, matches directory, max 64 chars
4. `description` max 1024 chars
5. `metadata.tags` is a non-empty list
6. `metadata.version` is valid semver (if present)
7. Only allowed top-level fields
8. SKILL.md under 500 lines
9. No duplicate skill names

## Tags

Use lowercase, hyphenated tags:

- **General:** `swe`, `devops`, `api`, `cli`, `observability`, `debugging`, `tooling`, `planning`, `code-review`
- **Domain:** `frontend`, `backend`, `data`, `infra`, `security`, `testing`, `docs`

## Version Bumps

When modifying a skill's content, bump the `metadata.version` field. CI warns on content changes without a version bump.

## Registering a Skill

Add the skill path to `.claude-plugin/marketplace.json` under the `skills` array:

```json
"skills": [
  "./skills/dmp-my-skill"
]
```
