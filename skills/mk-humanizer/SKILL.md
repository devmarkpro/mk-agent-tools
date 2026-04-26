---
name: mk-humanizer
description: >
  Remove AI writing patterns from text with special focus on technical writing
  and diagram-as-code. Detects content type, applies pattern-specific rewrites,
  and calibrates voice for the doc type. Trigger when user asks to humanize,
  clean up, or rewrite text to sound less AI-generated.
disable-model-invocation: true
metadata:
  tags:
    - writing
    - docs
    - code-review
    - devex
  author: devmarkpro
  version: "1.1.0"
---

# Mk Humanizer

Remove signs of AI-generated writing from any text, with dedicated pattern catalogs for technical documentation and diagram-as-code. Detects content type automatically and calibrates voice accordingly — crisp and direct for API docs, opinionated for ADRs, precise for specs.

## When to Use This Skill

**Trigger when:**
- User says `/mk-humanizer`
- User asks to "humanize this", "make this less AI", "clean up this text"
- User asks to "rewrite this naturally", "remove AI patterns"
- User pastes text and asks if it sounds AI-generated
- User asks to clean up a Mermaid diagram or diagram-as-code

**Do NOT trigger when:**
- User wants grammar or spell checking only (use a linter or grammar tool)
- User wants to translate text to another language (answer directly)
- User wants to generate new content from scratch (just write it)
- User asks about AI detection theory (answer conceptually)

## Prerequisites

| Requirement | Details |
|---|---|
| Pattern catalogs | `${CLAUDE_SKILL_DIR}/references/patterns.md`, `tech-patterns.md`, `diagram-patterns.md` |
| Input text | Text provided by user — prose, technical doc, diagram code, or mixed |

---

## Workflow

### Step 1: Detect Content Type

**Goal:** Classify the input so the right pattern catalogs and voice rules apply.

**Acceptance:** One or more content types assigned from: `general`, `technical`, `diagram`, `mixed`.

**How to classify:**
- Contains code blocks with `mermaid`, `plantuml`, `d2`, or diagram-like syntax → `diagram`
- Contains API references, config examples, architecture language, code snippets, or engineering terminology → `technical`
- Contains both technical and non-technical prose → `mixed`
- Otherwise → `general`

For `mixed` content, apply technical rules to technical sections and general rules to prose sections.

### Step 2: Load Applicable Patterns

**Goal:** Read the right pattern catalogs for the detected content type.

**Acceptance:** All relevant pattern files loaded before scanning.

| Content Type | Pattern Files |
|---|---|
| `general` | `patterns.md` |
| `technical` | `patterns.md` + `tech-patterns.md` |
| `diagram` | `diagram-patterns.md` |
| `mixed` | All three |

Read from `${CLAUDE_SKILL_DIR}/references/`.

### Step 3: Scan and Identify Patterns

**Goal:** Find every instance of an AI writing pattern in the input text.

**Acceptance:** Each identified pattern is tagged with its catalog ID (e.g., P7, T3, D2) and the specific text that triggered it.

**Constraints:**
- Never flag technical terms, code, commands, or config as "AI patterns"
- Never flag precise technical language as "vague" just because it's formal
- For diagrams: focus on structure and labeling, not syntax correctness

### Step 4: Rewrite

**Goal:** Remove identified AI patterns while preserving meaning, technical accuracy, and appropriate voice.

**Acceptance:** Rewritten text contains zero flagged patterns, reads naturally, and all technical content remains accurate.

**Voice calibration by doc type:**

| Doc Type | Voice | Personality |
|---|---|---|
| API docs, READMEs, setup guides | Maximum clarity, no personality injection | Direct, scannable, zero filler |
| ADRs, postmortems | Measured opinions welcome | "We chose X because Y felt too risky" is good |
| Tech specs, RFCs | Precise, kill all filler | Positions on trade-offs expected |
| PR descriptions, changelogs | Concise, factual | State what changed and why, nothing more |
| General prose, blog posts | Natural voice, personality allowed | Varied rhythm, opinions, first person when appropriate |
| Diagram code | Descriptive labels, clear structure | No prose voice — focus on readability and meaning |

**Constraints:**
- Never rewrite code examples, commands, config snippets, or precise technical terms
- Never add personality to API docs or reference material
- Never simplify technical precision in the name of "humanizing" — "reduces p99 latency from 450ms to 120ms" is good, leave it alone
- For diagrams: fix labels, grouping, and structure; don't change the diagram's meaning

### Step 5: Anti-AI Audit Pass

**Goal:** Catch remaining AI tells that survived the rewrite.

**Acceptance:** Final text passes the "would a human have written this?" test.

**Process:**
1. Read the rewritten text and ask: "What makes this obviously AI-generated?"
2. List remaining tells (2-5 bullets max)
3. If tells remain: fix them and produce the final version
4. If none remain: the rewrite from Step 4 is final

### Step 6: Present Result

**Goal:** Deliver the humanized text with a brief summary of what changed.

**Acceptance:** User receives the final text and understands what was fixed.

**Output format:**
1. Final rewritten text
2. Brief change summary (patterns found and fixed, grouped by category)
3. If diagram content: the cleaned diagram code block

---

## Edge Cases

| Situation | Handling |
|-----------|----------|
| Text is already natural and well-written | Say so — don't force changes where none are needed |
| Text is purely code (not prose or diagrams) | Not applicable — this skill is for written text and diagram-as-code, not source code |
| Mixed content (prose + code blocks) | Humanize the prose, leave code blocks untouched, clean up diagram blocks |
| Technical accuracy unclear | Preserve the original phrasing; flag uncertainty rather than risk changing meaning |
| User explicitly chose formal language | Respect intent — formal is not the same as AI-generated |
| Very short input (1-2 sentences) | Still scan and fix, but skip the audit pass — there's not enough text to warrant it |
| Diagram has no labels at all | Add descriptive labels based on context, flag additions for user review |
| Diagram uses unknown tool syntax | Apply tool-agnostic principles only; don't guess at tool-specific fixes |
| User disagrees with a rewrite | Revert that specific change, explain the pattern that triggered it |
| Text mixes languages (e.g., English + code + YAML) | Apply patterns only to natural language sections |
| User provides HTML or Markdown with embedded prose | Humanize the prose content, preserve all markup and structure |
| Text contains AI-written but factually critical claims | Preserve the factual content, rewrite only the delivery style |

## Tools

**Built-in (required):**
- Read — loading pattern catalogs from references/
- Edit — applying rewrites to files when requested

## Examples

### Triggering Prompts
- `/mk-humanizer`
- `Humanize this README`
- `This PR description sounds too AI — can you clean it up?`
- `Make this ADR sound like a human wrote it`
- `Clean up this Mermaid diagram`
- `Does this text sound AI-generated? Fix it if so`
- `Rewrite this tech spec more naturally`
- `This changelog reads like ChatGPT wrote it`

### Non-Triggering Prompts
- `Fix the grammar in this paragraph` (use a grammar tool)
- `Translate this to Spanish` (just translate directly)
- `Write me a README for this project` (just write it)
- `How do AI detectors work?` (answer conceptually)
- `Check this code for bugs` (use a code review skill)

## Success Criteria

1. Content type is correctly detected (general / technical / diagram / mixed)
2. All applicable pattern catalogs are loaded for the detected type
3. AI patterns are identified with specific catalog IDs
4. Rewritten text contains no remaining flagged patterns
5. Technical accuracy is preserved — no code, commands, or precise terms altered
6. Voice matches the doc type (no personality in API docs, opinions allowed in ADRs)
7. Diagram code has descriptive labels, clear grouping, and consistent direction
8. Anti-AI audit pass catches remaining tells and fixes them
9. Code blocks (non-diagram) are left completely untouched
10. User receives the final text with a summary of changes
11. When text is already natural, the skill says so rather than forcing changes
12. Mixed content sections (prose + code + diagrams) are independently classified and treated with appropriate rules
13. No false positives on formal-but-human technical language

## Reference Files

| File | Purpose |
|------|---------|
| `references/patterns.md` | General AI writing patterns — 29 patterns from Wikipedia + academic research |
| `references/tech-patterns.md` | Technical writing-specific AI patterns — 10 patterns |
| `references/diagram-patterns.md` | Diagram-as-code patterns — 8 patterns, Mermaid-specific + tool-agnostic |
