# Skill Schema v2.0

Source of truth for skill structure. Read this file before every validation run.

> **v2.0** — Adds all official Claude Code frontmatter fields, compaction-aware authoring guidance, SAFETY RULE pattern, string substitutions, dynamic context injection, and subagent execution.

## File Structure

```
.claude/skills/<name>/
  SKILL.md          # Required — the skill definition
  references/       # Optional — format docs, reference material
  scripts/          # Optional — helper scripts
  examples/         # Optional — worked examples of skill execution
```

- Folder name MUST be kebab-case, max 64 characters
- Folder name MUST match the `name` frontmatter field exactly

## Frontmatter

All fields are YAML between `---` markers. Organized by usage frequency.

### Core (every skill should have these)

| Field | Required | Rules |
|-------|----------|-------|
| `name` | Yes | kebab-case, matches folder name, max 64 chars |
| `description` | Yes | Multi-line YAML scalar (`>`), 1-4 sentences. MUST end with trigger hint ("Trigger when..." or "Trigger with..."). See [Description Optimization](#description-optimization). |

### Behavioral (use when skill needs non-default behavior)

| Field | Default | When to Use |
|-------|---------|-------------|
| `argument-hint` | none | Skill accepts arguments. Shown in autocomplete. Example: `"[issue-number]"`, `"<URL \| file-path>"` |
| `allowed-tools` | none | Pre-approve tools so Claude skips permission prompts. Space-separated string or YAML list. Does NOT restrict available tools — only grants auto-approval. |
| `disable-model-invocation` | `false` | `true` = only user can invoke via `/name`. Use for destructive, high-cost, or side-effect-heavy skills. |
| `user-invocable` | `true` | `false` = hidden from `/` menu, only Claude can invoke. Use for background knowledge skills. |
| `paths` | none | Glob patterns (comma-separated or YAML list) limiting auto-activation to matching files. |

### Advanced (specialized use cases)

| Field | Default | When to Use |
|-------|---------|-------------|
| `model` | session | Override model: `sonnet`, `opus`, `haiku`. Prefer session-level selection. |
| `effort` | session | Override effort: `low`, `medium`, `high`, `max` (Opus only). |
| `context` | none | `fork` to run in an isolated subagent. Skill content becomes the subagent prompt. |
| `agent` | `general-purpose` | Subagent type when `context: fork`. Built-in: `Explore`, `Plan`, `general-purpose`. Custom: any `.claude/agents/` file. |
| `hooks` | none | Lifecycle hooks scoped to this skill. See [Claude Code hooks docs](https://docs.anthropic.com/en/docs/claude-code/hooks). |
| `shell` | `bash` | Shell for `` !`command` `` blocks: `bash` or `powershell`. |

### Marketplace (optional, for skills distributed via a marketplace)

| Field | Required | Rules |
|-------|----------|-------|
| `metadata` | No | Container object for marketplace metadata |
| `metadata.tags` | Marketplace only | Non-empty YAML list of lowercase hyphenated tags |
| `metadata.author` | No | Freeform attribution string |
| `metadata.version` | No | Semantic version string (e.g., `"1.0.0"`) |

**Validation rule:** Fields not in these tables are invalid. The validator warns on unknown fields.

### Description Optimization

The first **250 characters** of `description` are shown in skill listings — everything after is truncated. Front-load the primary use case and outcome.

```yaml
# Good — key use case in first 250 chars:
description: >
  Core wiki operation. Processes any source (article URL, file path,
  document) into the wiki. Trigger with "/ingest <source>".

# Bad — buried use case:
description: >
  This is a comprehensive skill that handles various types of content
  processing workflows across multiple input formats and output targets
  for the purpose of wiki knowledge management. Trigger with "/ingest".
```

## Required Sections (in order)

### 1. H1 Title

- `# Title Case Name` matching title-case of `name` (e.g., `meeting-importer` -> `# Meeting Importer`)
- Followed immediately by a 1-2 sentence summary paragraph

### 2. SAFETY RULE (conditional)

**Include when** the skill has side effects on external systems (sending email, posting messages, writing to external services, modifying external data).

Place immediately after the H1 summary paragraph, before `## When to Use This Skill`:

```markdown
### SAFETY RULE — <CONSTRAINT>

This skill <does X> but **NEVER** <does Y>. <Brief explanation>.
```

Standard patterns:

| Pattern | When to Use |
|---------|-------------|
| `SAFETY RULE — READ-ONLY` | Skill reads from external services but must not write |
| `SAFETY RULE — DRAFT ONLY, NEVER SEND` | Skill creates drafts (email, messages) but must not send |
| `SAFETY RULE — NO <ACTION>` | Skill must not perform a specific destructive action |

### 3. When to Use This Skill

```markdown
## When to Use This Skill

**Trigger when:**
- User asks to...
- User mentions...

**Do NOT trigger when:**
- User asks about... (use X skill instead)
- User wants... (use Y tool instead)
```

- MUST contain trigger conditions (what activates the skill)
- MUST contain anti-triggers with redirects (what should NOT activate it)

### 4. Prerequisites

Table format required. List all external dependencies: tools, running services, files, permissions.

```markdown
| Requirement | Details |
|-------------|---------|
| Tool/Service | Version or location |
```

### 5. Workflow or Architecture

- H2: `## Workflow` (linear) or `## Architecture` (complex/branching)
- Numbered steps or phases with H3 subheadings (`### Step N:` or `### Phase N:`)
- **Declarative authoring:** Each step describes the *goal* (what to achieve) and *acceptance criteria* (how to know it worked), not specific commands or tools. The executing agent determines the how based on available environment.

```markdown
## Workflow

### Phase 1: [Phase Name]

**Goal:** [What this step achieves]
**Acceptance:** [How to verify it worked]
**Constraints:** [What to avoid — optional]
```

**Do NOT** write workflow steps like:
```markdown
### Step 1: Validate config
Run `python3 validate.py config.yml` to check the configuration.
```

**Instead** write:
```markdown
### Step 1: Validate configuration
**Goal:** Verify the configuration file is structurally valid and all required fields are present.
**Acceptance:** Validation passes with no errors, or a clear error report is presented to the user.
```

The agent running the skill will determine the best way to validate — it might use a built-in parser, a CLI tool, or direct file inspection depending on what's available.

### 6. Edge Cases

Table format required. Must cover at minimum: missing data, tool unavailability, ambiguous input.

```markdown
| Situation | Handling |
|-----------|----------|
| Missing data | Behavior description |
```

### 7. Tools

```markdown
## Tools

**Built-in:**
- Read — reading project files
- Grep — searching content

**MCP Tools (optional):**
- Web search — documentation lookup
```

- Bullet list grouped by category, mark tools as required vs optional
- If `allowed-tools` is in frontmatter, tools listed here should match

### 8. Examples

```markdown
## Examples

### Triggering Prompts
- `User: Generate my weekly report`
- `User: What happened this week?`

### Non-Triggering Prompts
- `User: Show me today's daily note` (use other-skill instead)
- `User: What meetings do I have tomorrow?` (use meeting-prep instead)
```

- Must have both triggering and non-triggering subsections
- Non-triggering prompts include redirect hints in parentheses
- 4-8 examples per subsection
- For complex multi-step examples, use an `examples/` subdirectory and reference from `## Reference Files`

### 9. Success Criteria

```markdown
## Success Criteria

1. All X are processed without errors
2. Output contains Y
3. Links resolve correctly
```

- Numbered list, 5-12 items
- Written as assertions: "X is Y" or "All X are Y"
- Measurable outcomes, not process steps

## Optional Sections

| Section | When to Include | Format |
|---------|----------------|--------|
| `## What This Skill Does` | Skill has 8+ distinct operations | Numbered list after "When to Use" |
| `## Validation Checklist` | Skill produces artifacts needing verification | Checkbox list after Success Criteria |
| `## Troubleshooting` | Skill involves external tools/services | Table: Problem / Cause / Fix |
| `## Tips` | Practical gotchas exist | Numbered list |
| `## Reference Files` | Any subdirectory (references/, scripts/, examples/) has files | Table: File / Purpose |

## String Substitutions

Substitutions are resolved when the skill is rendered into conversation context.

| Variable | Expands To | Example |
|----------|-----------|---------|
| `$ARGUMENTS` | Full argument string as typed | `/ingest foo bar` -> `foo bar` |
| `$ARGUMENTS[N]` or `$N` | Nth argument, 0-indexed | `$0` -> `foo`, `$1` -> `bar` |
| `${CLAUDE_SESSION_ID}` | Current session ID | Unique filenames, logging |
| `${CLAUDE_SKILL_DIR}` | Absolute path to the skill's directory | Portable references to `scripts/` and `references/` |

Use `${CLAUDE_SKILL_DIR}` instead of hardcoded paths when referencing supporting files.

## Dynamic Context Injection

Shell commands prefixed with `!` run at skill render time. Output replaces the marker.

**Inline:** `` !`command` `` — single command, output inlined.

**Block:**
````markdown
```!
node --version
git status --short
```
````

- Commands run **before** Claude sees the skill content — this is preprocessing, not execution
- Keep commands fast (< 1 second) — they block skill rendering
- Use for: current date, environment state, file listings, config values

## Subagent Execution

Set `context: fork` to run the skill in an isolated subagent conversation. The subagent receives the skill content as its prompt but **not** the parent conversation history.

```yaml
---
name: deep-research
context: fork
agent: Explore
---
```

Use when the skill is a self-contained pipeline that doesn't need conversational context. Combine with `agent:` to pick the execution environment (built-in agents like `Explore`, `Plan`, or custom agents from `.claude/agents/`).

## Skill Content Lifecycle

When invoked, rendered SKILL.md enters the conversation as a single message and stays for the session. During **auto-compaction** (when context fills up):

- Claude Code re-attaches the most recent invocation of each skill
- Each skill retains only its **first 5,000 tokens** (~400 lines)
- All re-attached skills share a combined **25,000-token budget**
- Most recently invoked skills get priority; older skills may be dropped entirely

**Implications for skill authors:**

1. **Front-load critical content** — SAFETY RULE, triggers, and core workflow steps must appear early. Compaction truncates from the end.
2. **Target under 5,000 tokens** (~400 lines) for SKILL.md itself
3. **Offload reference material** — Move lengthy content to `references/` or `examples/` directories (read on demand, not subject to compaction budget)
4. **Re-invoke after compaction** — If a skill stops influencing behavior, the user can re-invoke it with `/name` to restore full content

## Formatting Rules

1. **Tables** for: prerequisites, edge cases, field mappings, troubleshooting
2. **Code blocks** with language tags (`bash`, `yaml`, `json`, `markdown`) for all code
3. **Bold emphasis** for: CRITICAL, MUST, NEVER, ALWAYS — use sparingly
4. **Numbered lists** for: sequential workflows, success criteria
5. **Bullet lists** for: non-sequential items, tool listings
6. **H2** for top-level sections, **H3** for subsections, **H4** max depth
7. **Horizontal rules** (`---`) between major sections only when skill exceeds 200 lines

## Quality Criteria

1. **Declarative**: Workflow steps describe goals and acceptance criteria, not specific commands, tools, or languages
2. **Environment-agnostic**: Skill makes no assumptions about OS, language runtime, or CLI availability beyond Claude Code built-ins
3. **Self-contained**: Skill executable from SKILL.md + supporting files alone
4. **Unambiguous triggers**: A user prompt maps to exactly one skill
5. **Graceful degradation**: Edge cases cover tool/data unavailability
6. **Pattern consistency**: Section order matches this schema
7. **No orphan references**: Every mentioned file/tool/entity exists or is marked optional
8. **Length**: 100-500 lines for SKILL.md. Above 400 lines, verify total stays under 5,000 tokens
9. **Trigger clarity**: "When to Use" prevents both false positives and false negatives
10. **Description front-loading**: First 250 chars convey the primary use case
11. **Frontmatter hygiene**: Only fields from the schema tables are present
12. **Safety declared**: Skills with external side effects include a SAFETY RULE block
