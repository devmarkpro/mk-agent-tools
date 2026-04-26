---
name: mk-adr
description: >
  Create, query, manage, and maintain Architecture Decision Records using the
  Michael Nygard template. Proactively suggests ADR creation on architecture
  changes. Validates prose with mk-humanizer. Trigger when user mentions ADR,
  architecture decisions, or asks "why" about architecture choices.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
metadata:
  tags:
    - docs
    - swe
    - planning
    - devex
  author: devmarkpro
  version: "1.1.0"
---

# Mk ADR

Create, query, manage, validate, and improve Architecture Decision Records using the Michael Nygard template. Validates all ADR prose through mk-humanizer when available. Falls back to manual formatting rules when it's not.

ADRs are living documentation — this skill doesn't just create them, it keeps them healthy, surfaces them in conversation, cross-references with git history, and suggests improvements when they fall behind reality.

## When to Use This Skill

**Trigger when:**
- User asks to create, update, or manage an ADR
- User mentions "ADR", "architecture decision record", or "decision record"
- User asks "why" a particular architecture choice was made
- User asks to list, search, summarize, or query ADRs
- User asks for an ADR health check or consistency review
- User asks about history or evolution of an architecture component

**Proactively suggest** (don't block) creating an ADR when the user is:
- Adding, replacing, or removing a major dependency
- Changing the API style or communication pattern
- Introducing new infrastructure components
- Modifying the deployment strategy
- Changing the authentication/authorization approach
- Restructuring the project layout or module boundaries

Frame as: "This looks like an architecture decision worth recording. Want me to create an ADR for it?"

**Do NOT trigger when:**
- Bug fixes, minor refactors, or cosmetic changes (not architectural)
- Configuration changes that don't affect architecture (not this skill)

## Prerequisites

| Requirement | Details |
|---|---|
| ADR directory | Discover by checking: `.adr-dir` file, then `doc/adr/`, `docs/adr/`, `adr/` — create if none found |
| Nygard template | `${CLAUDE_SKILL_DIR}/references/nygard-template.md` — every ADR must use this structure |
| `adr-tools` CLI | Optional — see `${CLAUDE_SKILL_DIR}/references/adr-tools-reference.md` for fallbacks |
| mk-humanizer skill | Validates ADR prose — required when available, skip gracefully when not installed |

Read both reference files before any ADR operation.

---

## Workflow

### Humanizer Validation Rule

**All ADR prose must be validated by mk-humanizer.** This applies to:
- New ADRs: validate Context, Decision, and Consequences before finalizing
- Updated ADRs: validate changed sections before saving
- Health checks: scan all ADRs and report humanizer issue counts

**Process:**
1. Check if mk-humanizer is available (invoke `/mk-humanizer` — if it loads, it's available)
2. If available: run it against the prose sections, fix any flagged patterns
3. If not available: apply these minimum checks manually:
   - No promotional language or puffed-up significance
   - No vague attributions ("experts believe", "industry observers")
   - Active voice in Decision section ("We will..." not "It was decided...")
   - No filler phrases, no em dash overuse, no rule-of-three padding
   - Consequences include real trade-offs, not generic optimism

### Phase 1: Create a New ADR

**Goal:** Record an architecture decision in a well-structured, humanized ADR file.

**Steps:**
1. **Gather context** — Ask about: what decision was made, what forces led to it, what alternatives were considered, what consequences are expected
2. **Find the ADR directory** — Check for `.adr-dir` file, then common locations (`doc/adr/`, `docs/adr/`, `adr/`). If none exists, ask user where to store ADRs and create the directory
3. **Check for related ADRs** — Scan existing ADRs for keyword overlap; suggest linking if related ADRs exist
4. **Determine numbering** — Find the highest existing ADR number and increment
5. **Check for superseded decisions** — Ask if this replaces a previous ADR
6. **Create the file** — Use `adr-tools` if available, otherwise create manually. Must follow the Nygard template from `${CLAUDE_SKILL_DIR}/references/nygard-template.md`:
   - **Title**: `# <number>. <Short noun phrase>`
   - **Date**: today (YYYY-MM-DD)
   - **Status**: Proposed, Accepted, Deprecated, or Superseded
   - **Context**: forces at play, constraints, problem description
   - **Decision**: active voice declaration ("We will...")
   - **Consequences**: what becomes easier/harder, trade-offs
7. **Validate with mk-humanizer** — Run mk-humanizer on the Context, Decision, and Consequences sections. Fix any AI-writing patterns before finalizing. If mk-humanizer is not available, apply the minimum manual checks from the Humanizer Validation Rule above
8. **Update the index** — Regenerate the ADR directory's README or TOC if one exists

**Acceptance:** ADR file created with correct numbering, valid Nygard template structure, and prose that passes humanizer validation.

### Phase 2: Query and Read ADRs

**Goal:** Answer questions about architecture decisions by finding and synthesizing from existing ADRs.

| Query type | Approach |
|-----------|----------|
| "What are the last N ADRs?" | List files by number, present title/status/date table |
| "Why was X decided?" | Search ADRs for keywords, synthesize from Context/Decision, cite ADR number |
| "Show ADRs about \<topic\>" | Keyword search, present matches with one-line summaries |
| "Show ADRs with status \<status\>" | Filter by status, present matches |
| "Show relationship graph" | Parse Status sections for links, generate Mermaid diagram |

**Acceptance:** Specific ADR numbers cited in every answer. If no ADR covers the topic, say so and offer to create one.

### Phase 3: Link and Supersede ADRs

**Goal:** Maintain bidirectional links between related ADRs.

**Linking** (amends, extends, conflicts with):
- Update the Status section of both ADRs with the appropriate link type
- See `${CLAUDE_SKILL_DIR}/references/adr-tools-reference.md` for link types and procedures

**Superseding:**
- Create new ADR with `Supersedes [N. Old Title](old-file.md)` in Status
- Update old ADR status to `Superseded by [N. New Title](new-file.md)`

**After any content update**, validate changed prose sections with mk-humanizer.

**Acceptance:** Both ADRs updated with bidirectional links. Prose passes humanizer validation.

### Phase 4: Health Check

**Goal:** Assess the quality and consistency of all ADRs.

Run these checks across all ADRs in the ADR directory:

1. **Template consistency** — Verify each has: Title (with number), Date, Status, Context, Decision, Consequences. Flag extra or missing sections.
2. **Stale proposals** — Find "Proposed" ADRs older than 30 days; prompt for resolution.
3. **Broken supersession chains** — If "Superseded by X" but X doesn't exist or doesn't reference back, flag it.
4. **Missing links** — If ADRs reference each other in text but have no formal Status link, suggest adding one.
5. **Prose quality** — Run mk-humanizer against each ADR's Context, Decision, and Consequences sections. Report issue count per ADR. Offer to fix automatically.

**Acceptance:** Report listing all issues found, grouped by ADR and category.

### Phase 5: Git History Cross-Reference

**Goal:** Enrich ADR answers with implementation evidence from git history.

When answering "why" questions or reviewing ADR health:
- Search git history around the ADR's date for related commits
- Present a timeline combining the ADR decision date with implementing commits
- If an accepted ADR has no implementation evidence, flag it
- When creating a new ADR, show recent git history to inform the Context section

**Acceptance:** Timeline with commit hashes and dates when git evidence is available.

### Phase 6: Improvement Suggestions

**Goal:** Continuously improve ADR quality during every read operation.

| Issue | Suggestion |
|-------|-----------|
| Thin Context (< 2 sentences) | "Consider adding alternatives evaluated and constraints" |
| One-sided Consequences | "Adding trade-offs makes the record more useful" |
| Vague Decision (no active voice) | "Rewrite as firm declaration: 'We will...'" |
| Stale Accepted ADR | "ADR says X but codebase shows Y — supersede or update" |
| Missing date or wrong format | "Add or fix the Date field" |
| Title doesn't match content | "Title suggests X but Decision describes Y" |

Be specific, batch per ADR, prioritize by impact. Always frame as suggestions.

### Phase 7: Index and Diagram Generation

**Summary index** — Generate or update the ADR directory's README with a table: number, title (linked), status, date.

**Relationship diagram** — Generate Mermaid diagram with status indicators and link types between ADRs.

---

## Edge Cases

| Situation | Handling |
|-----------|----------|
| `adr-tools` not installed | Use fallback procedures from `${CLAUDE_SKILL_DIR}/references/adr-tools-reference.md` |
| No ADR directory exists | Ask user for preferred location, create it, suggest ADR-0001 "Record architecture decisions" |
| User asks about topic no ADR covers | Say so honestly, offer to create one |
| Ambiguous query matches multiple ADRs | Present all matches with summaries, let user choose |
| ADR uses non-standard template | Warn about inconsistency, suggest updating to Nygard format |
| Broken supersession chain | Flag the broken link during health check |
| mk-humanizer not available | Apply minimum manual prose checks from the Humanizer Validation Rule |
| ADR directory in non-standard location | Check `.adr-dir` file first, then ask user |

## Tools

**Built-in:**
- Read — reading ADR files and references
- Bash — running `adr-tools` commands, git log, file operations
- Edit — updating ADR content and status links
- Write — creating new ADR files

**External (optional):**
- `adr-tools` CLI — streamlines create, link, supersede operations

**Agent (optional):**
- mk-humanizer — validates ADR prose (required when available, graceful fallback when not)

## Examples

### Triggering Prompts
- `Create an ADR for switching from PostgreSQL to CockroachDB`
- `/mk-adr`
- `Why did we decide to use JWT for authentication?`
- `What are the last 3 ADRs about?`
- `Run an ADR health check`
- `Generate the ADR relationship diagram`
- `Show me all ADRs related to the database`
- `When was the decision to use event sourcing actually implemented?`

### Non-Triggering Prompts
- `Fix the typo in the health check endpoint` (not architectural)
- `Update the logging format` (configuration, not architecture)
- `Write a commit message` (use mk-conventional-commits)
- `Review this pull request` (not this skill)

### Proactive Suggestion Scenario

```text
User: Let's replace the REST API with GraphQL for the new endpoints
Agent: This is an architectural change worth documenting.
       Want me to create an ADR for the decision to adopt GraphQL?
```

## Success Criteria

1. Every new ADR follows the Nygard template exactly (Title, Date, Status, Context, Decision, Consequences)
2. ADR numbering is sequential with no gaps or duplicates
3. The Status field contains a valid value (Proposed, Accepted, Deprecated, Superseded)
4. Supersession chains are bidirectional (old points to new, new points to old)
5. Historical "why" queries cite specific ADR numbers and titles
6. Git cross-references include commit hashes and dates when available
7. Health checks flag stale proposals, broken links, and template deviations
8. The ADR index stays current after each creation
9. Improvement suggestions are specific and actionable
10. ADR prose passes mk-humanizer validation on create and update
11. When mk-humanizer is unavailable, minimum manual prose checks are applied
12. Health check reports humanizer issue count per ADR

## Reference Files

| File | Purpose |
|------|---------|
| `references/nygard-template.md` | Mandatory ADR template structure with field descriptions and examples |
| `references/adr-tools-reference.md` | CLI reference and bash fallback commands for all ADR operations |

## Tips

1. Keep titles as short noun phrases — "Use PostgreSQL for storage" not "We decided to use PostgreSQL"
2. Context describes forces at play, not the solution
3. Decision uses active voice: "We will..." not "It was decided..."
4. Consequences should include both positive and negative outcomes
5. When answering historical "why" questions, always cite the ADR number and title
6. Treat every interaction with ADRs as an opportunity to improve them
7. Cross-reference git history whenever it adds value — commit evidence makes answers more credible
