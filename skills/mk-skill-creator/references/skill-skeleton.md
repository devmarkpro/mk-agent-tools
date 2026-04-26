# SKILL.md Skeleton — v2.0

Annotated template showing correct structure, section order, and format. Read this before drafting any skill.

---

## Frontmatter

```yaml
---
name: my-skill-name                    # REQUIRED: kebab-case, matches folder name
description: >                         # REQUIRED: CSO-optimized (see rules below)
  Primary use case in first 250 chars. Additional context. Ends with trigger
  hint. Trigger when user asks to X or says "/my-skill-name".
argument-hint: "<arg1> [--flag]"       # OPTIONAL: shown in autocomplete, include if skill takes args
allowed-tools:                         # OPTIONAL: pre-approve tools (does NOT restrict, only auto-approves)
  - Read
  - Write
  - Bash
# --- Rare fields (include only when needed) ---
# disable-model-invocation: true       # Only user can invoke via /name (destructive/costly skills)
# user-invocable: false                # Hidden from menu, only Claude invokes (background knowledge)
# paths: "src/**/*.ts"                 # Auto-activate only for matching files
# context: fork                        # Run in isolated subagent
# agent: Explore                       # Subagent type (with context: fork)
# model: sonnet                        # Override model (rare)
---
```

### Description Rules (CSO)

1. First 250 chars = primary use case (this is all that shows in skill listings)
2. End with "Trigger when..." or "Trigger with..."
3. **NEVER** summarize the workflow — describe only WHEN to use, not WHAT it does
4. Third person voice

```yaml
# BAD — summarizes workflow:
description: >
  Reads config files, validates schemas, creates reports, and updates dashboards.
  Trigger with "/process-config".

# GOOD — triggering conditions only:
description: >
  Validate and report on project configuration health. Trigger when user says
  "/process-config" or asks to check configuration for issues.
```

---

## Body Sections (in order)

### 1. H1 Title + Summary

```markdown
# My Skill Name

1-2 sentence summary. No narrative. State what the skill does and its key constraint.
```

- Title = Title Case of `name` field (`my-skill-name` -> `My Skill Name`)

### 2. SAFETY RULE (conditional)

**Include ONLY when skill has external side effects** (sends email, posts messages, writes to external services).

```markdown
### SAFETY RULE — READ-ONLY

This skill reads Gmail for context but **NEVER** sends, replies, or forwards email.
```

Standard patterns:
- `SAFETY RULE — READ-ONLY` — reads external services, never writes
- `SAFETY RULE — DRAFT ONLY, NEVER SEND` — creates drafts, never sends
- `SAFETY RULE — NO <ACTION>` — specific prohibition

### 3. When to Use This Skill

```markdown
## When to Use This Skill

**Trigger when:**
- User says "/my-skill", "natural language variant"
- User asks to [specific action]

**Do NOT trigger when:**
- User asks about X (use Y skill instead)
- User wants Z (use W tool directly)
```

- Anti-triggers MUST include parenthetical redirects

### 4. Prerequisites

```markdown
## Prerequisites

| Requirement | Details |
|-------------|---------|
| CLI tool | Version or location |
| MCP Tools | Web search — required; GitHub — optional |
```

### 5. Workflow

```markdown
## Workflow

### Phase 1: [Phase Name]

**Goal:** [What this step achieves — the desired outcome]
**Acceptance:** [How to verify the step succeeded]
**Constraints:** [What to avoid — optional]
```

- Use `Phase N:` for 5+ steps, `Step N:` for fewer
- Front-load critical steps (compaction keeps first ~150 lines)
- **Declarative:** Describe goals and acceptance criteria, never specific commands or tools
- The executing agent determines the how based on available environment

### 6. Edge Cases

```markdown
## Edge Cases

| Situation | Handling |
|-----------|----------|
| Missing data | Ask user, do not guess |
| Tool unavailable | Fall back to built-in tool, warn user |
| Ambiguous input | Present options, let user choose |
```

- 8-20 rows minimum
- MUST cover: missing data, tool unavailability, ambiguous input

### 7. Tools

```markdown
## Tools

**Built-in (required):**
- Read — reading project files
- Write — creating new files

**External CLI:**
- project-cli — project-specific operations

**MCP Tools (optional):**
- Web search — documentation lookup

**Agent:**
- skill-validator — automated validation (if applicable)
```

- Heading is `## Tools` (NOT `## Tools Used`)
- Group by category, mark required vs optional

### 8. Examples

```markdown
## Examples

### Triggering Prompts
- `/my-skill`
- `/my-skill some-argument`
- "Natural language that triggers this skill"
- "Another natural language variant"

### Non-Triggering Prompts
- "Related but different request" (use other-skill instead)
- "Similar-sounding but wrong" (use X tool directly)
```

- 5-8 triggering, 4-6 non-triggering
- Non-triggering MUST include redirect hints in parentheses

### 9. Success Criteria

```markdown
## Success Criteria

1. Output file exists at expected location
2. Frontmatter has all required fields
3. All links resolve correctly
4. User confirms output matches expectations
```

- Numbered list, 10-20 items
- Testable assertions: "X is Y", "All X are Y"

### 10. Optional Sections (include when applicable)

```markdown
## What This Skill Does       <!-- When skill has 8+ distinct operations -->
## Validation Checklist        <!-- When skill produces artifacts needing verification -->
## Troubleshooting             <!-- When skill involves external tools/services -->
## Tips                        <!-- When practical gotchas exist -->
## Reference Files             <!-- When references/, examples/, or scripts/ has files -->
```

### 11. Reference Files (when supporting files exist)

```markdown
## Reference Files

| File | Purpose |
|------|---------|
| `references/format-spec.md` | Detailed format specification |
| `examples/worked-example.md` | Complete worked example |
| `scripts/helper.py` | Utility script |
```

- Use `${CLAUDE_SKILL_DIR}` in SKILL.md body to reference these files portably

---

## Compaction Budget

- SKILL.md target: 100-500 lines, under 5,000 tokens (~3,750 words)
- First 5,000 tokens are retained during compaction
- SAFETY RULE + triggers should be in first ~40 lines
- Core workflow steps should be in first ~150 lines
- Offload reference material to `references/`, examples to `examples/`
