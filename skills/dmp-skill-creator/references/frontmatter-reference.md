# Frontmatter Field Reference — SKILL_SCHEMA v2.0

Decision guide for every frontmatter field. Read this during Phase 1 (Gather Requirements) to determine which fields to include.

---

## Core Fields (every skill)

### `name` (required)
- kebab-case, max 64 chars
- MUST match folder name exactly
- Example: `weekly-status-report`

### `description` (required)
- Multi-line YAML scalar (`>`)
- 1-4 sentences
- **CSO Rules:**
  - First 250 chars = primary use case (shown in skill listings — everything after truncated)
  - End with "Trigger when..." or "Trigger with..."
  - NEVER summarize the workflow (Claude may follow description instead of reading full skill)
  - Third person voice

**Decision:** Always include. Spend time getting it right — it determines whether Claude finds and correctly invokes your skill.

---

## Behavioral Fields (use when skill needs non-default behavior)

### `argument-hint`
- Shown in autocomplete after `/name`
- Example: `"<URL | file-path | --batch>"`, `"[issue-number]"`

**Decision:** Include when skill accepts arguments via `$ARGUMENTS`. Skip for argumentless skills.

### `allowed-tools`
- Space-separated string or YAML list
- Pre-approves tools so Claude skips permission prompts
- Does NOT restrict available tools

**Decision:** Include when skill uses 3+ tools consistently.

### `disable-model-invocation`
- Default: `false`
- When `true`: only user can invoke via `/name` (Claude cannot auto-invoke)

**Decision:** Set `true` for destructive skills (delete, archive), high-cost skills (long-running subagents), or side-effect-heavy skills (posting to external services).

### `user-invocable`
- Default: `true`
- When `false`: hidden from `/` menu, only Claude can invoke

**Decision:** Set `false` for background knowledge skills that Claude references internally but users shouldn't invoke directly.

### `paths`
- Glob patterns (comma-separated or YAML list)
- Limits auto-activation to matching files

**Decision:** Include for file-type-specific skills (e.g., a skill that only applies to `.py` files or files under `src/`).

---

## Advanced Fields (specialized use cases)

### `context: fork`
- Runs skill in isolated subagent conversation
- Subagent receives skill content as prompt but NOT parent conversation history

**Decision:** Use for self-contained pipelines that don't need conversational context. Always pair with `agent:`.

### `agent`
- Subagent type when `context: fork`
- Built-in: `Explore`, `Plan`, `general-purpose`
- Custom: any `.claude/agents/` filename

**Decision:** Required when `context: fork` is set. Choose agent type matching the skill's primary activity.

### `model`
- Override model: `sonnet`, `opus`, `haiku`
- Default: session-level selection

**Decision:** Rarely needed. Use `haiku` for simple/fast skills, `opus` for complex reasoning. Prefer session-level selection.

### `effort`
- Override effort: `low`, `medium`, `high`, `max`
- Opus only

**Decision:** Rarely needed. Only for skills that need consistently high reasoning regardless of session setting.

### `hooks`
- Lifecycle hooks scoped to this skill
- See Claude Code hooks docs

**Decision:** For skills that need pre/post processing hooks.

### `shell`
- Default: `bash`
- Alternative: `powershell`

**Decision:** Only set if skill targets Windows environments.

---

## String Substitutions

Resolved at skill render time (before Claude sees the content):

| Variable | Expands To | Example |
|----------|-----------|---------|
| `$ARGUMENTS` | Full argument string | `/ingest foo bar` -> `foo bar` |
| `$ARGUMENTS[N]` or `$N` | Nth argument, 0-indexed | `$0` -> `foo`, `$1` -> `bar` |
| `${CLAUDE_SESSION_ID}` | Current session ID | Unique filenames, logging |
| `${CLAUDE_SKILL_DIR}` | Absolute path to skill's directory | Portable references to `references/` |

**Always use `${CLAUDE_SKILL_DIR}`** instead of hardcoded paths when referencing supporting files.

---

## Dynamic Context Injection

Shell commands prefixed with `!` run at skill render time. Output replaces the marker.

**Inline:** `` !`command` `` — single command, output inlined
**Block:**
````
```!
git status --short
date +%Y-%m-%d
```
````

- Commands run BEFORE Claude sees the skill content (preprocessing)
- Keep commands fast (< 1 second)
- Use for: current date, environment state, file listings, config values

---

## Quick Decision Flowchart

```
Does skill accept arguments?
  YES -> add argument-hint
  NO  -> skip

Does skill use 3+ tools consistently?
  YES -> add allowed-tools
  NO  -> skip

Does skill have external side effects?
  YES -> consider disable-model-invocation: true
  NO  -> skip

Is skill background knowledge only?
  YES -> user-invocable: false
  NO  -> skip (default true)

Does skill need isolation from conversation?
  YES -> context: fork + agent: <type>
  NO  -> skip
```
