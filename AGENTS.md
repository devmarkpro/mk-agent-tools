# Agent Guidelines

This is a Claude Code skills marketplace. All skills live under `skills/` and are prefixed with `dmp-`.

## When working in this repo

- Follow the structure defined in CONTRIBUTING.md
- Skill directories must be named `dmp-<name>` (lowercase, hyphens only)
- Each skill has a `SKILL.md` under 500 lines with required YAML frontmatter
- Run `./scripts/lint-skills.sh` before committing changes to skills
- Register new skills in `.claude-plugin/marketplace.json`
- Reference material goes in `references/` subdirectories, not in SKILL.md
