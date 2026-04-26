# agent-tools

Personal Claude Code skills marketplace by [devmarkpro](https://github.com/devmarkpro).

All skills are prefixed with `dmp-` and follow the [Agent Skills specification](https://agentskills.io/specification).

## Structure

```
agent-tools/
├── .claude-plugin/
│   └── marketplace.json        # Plugin registry
├── scripts/
│   ├── lint-skills.sh          # Validate SKILL.md format
│   └── check-version-bump.sh   # Detect missing version bumps
├── skills/
│   └── dmp-<skill-name>/
│       ├── SKILL.md            # Skill definition (<500 lines)
│       └── references/         # Optional supporting docs
├── CONTRIBUTING.md
├── SKILL_TEMPLATE.md
└── README.md
```

## Installing Skills

### Option 1: Claude Code Marketplace

```bash
claude plugin marketplace add git@github.com:devmarkpro/agent-tools.git
claude plugin install dmp-skills@dmp-agent-skills
```

### Option 2: Via settings.json

Add the plugin entry to your `~/.claude/settings.json`:

```json
{
  "plugins": [
    "git@github.com:devmarkpro/agent-tools.git"
  ]
}
```

### Option 3: Manual (development)

```bash
git clone git@github.com:devmarkpro/agent-tools.git
ln -s ~/agent-tools/skills/dmp-<skill-name> ~/.claude/skills/dmp-<skill-name>
```

## Available Skills

| Skill | Description | Tags |
|-------|-------------|------|
| [dmp-skill-creator](skills/dmp-skill-creator/) | Dual-mode skill factory: create new skills from natural language or audit existing skills against SKILL_SCHEMA v2.0 | `swe`, `tooling`, `devex`, `planning` |

## Creating a New Skill

1. Copy `SKILL_TEMPLATE.md` to `skills/dmp-<name>/SKILL.md`
2. Fill in frontmatter and content
3. Add optional `references/` directory for supporting docs
4. Register in `.claude-plugin/marketplace.json`
5. Run `./scripts/lint-skills.sh` to validate
6. Open a PR

## Skill Format

```yaml
---
name: dmp-my-skill
description: One-line summary of what this skill does
metadata:
  tags:
    - relevant-tag
  author: devmarkpro
  version: "1.0.0"
---
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for full format details and validation rules.

## Specification

Skills follow the [Agent Skills spec](https://agentskills.io/specification).
