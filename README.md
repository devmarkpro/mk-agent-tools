# agent-tools

Personal Claude Code skills marketplace by [devmarkpro](https://github.com/devmarkpro).

All skills are prefixed with `mk-` and follow the [Agent Skills specification](https://agentskills.io/specification).

## Structure

```
agent-tools/
├── .claude-plugin/
│   └── marketplace.json        # Plugin registry
├── scripts/
│   ├── lint-skills.sh          # Validate SKILL.md format
│   └── check-version-bump.sh   # Detect missing version bumps
├── skills/
│   └── mk-<skill-name>/
│       ├── SKILL.md            # Skill definition (<500 lines)
│       └── references/         # Optional supporting docs
├── CONTRIBUTING.md
├── SKILL_TEMPLATE.md
└── README.md
```

## Installing Skills

### Option 1: Claude Code Marketplace

```bash
claude plugin marketplace add git@github.com:devmarkpro/mk-agent-tools.git
claude plugin install mk-skills@mk-agent-skills
```

### Option 2: Via settings.json

Add the plugin entry to your `~/.claude/settings.json`:

```json
{
  "plugins": [
    "git@github.com:devmarkpro/mk-agent-tools.git"
  ]
}
```

### Option 3: Manual (development)

```bash
git clone git@github.com:devmarkpro/mk-agent-tools.git
ln -s ~/mk-agent-tools/skills/mk-<skill-name> ~/.claude/skills/mk-<skill-name>
```

## Available Skills

| Skill | Description | Tags |
|-------|-------------|------|
| [mk-skill-creator](skills/mk-skill-creator/) | Dual-mode skill factory: create new skills from natural language or audit existing skills against SKILL_SCHEMA v2.0 | `swe`, `tooling`, `devex`, `planning` |
| [mk-humanizer](skills/mk-humanizer/) | Remove AI writing patterns from text with focus on technical writing and diagram-as-code | `writing`, `docs`, `code-review`, `devex` |
| [mk-conventional-commits](skills/mk-conventional-commits/) | Write git commit messages following the Conventional Commits v1.0.0 spec | `git`, `swe`, `devex` |
| [mk-adr](skills/mk-adr/) | Create, query, manage, and maintain Architecture Decision Records using the Nygard template | `docs`, `swe`, `planning`, `devex` |

## Creating a New Skill

1. Copy `SKILL_TEMPLATE.md` to `skills/mk-<name>/SKILL.md`
2. Fill in frontmatter and content
3. Add optional `references/` directory for supporting docs
4. Register in `.claude-plugin/marketplace.json`
5. Run `./scripts/lint-skills.sh` to validate
6. Open a PR

## Skill Format

```yaml
---
name: mk-my-skill
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
