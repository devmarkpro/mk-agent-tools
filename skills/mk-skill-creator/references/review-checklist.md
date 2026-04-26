# Skill Review Checklist — v2.0

Use during Review Mode (Phase R2) to audit an existing skill beyond the automated validator.

---

## 1. Schema Compliance (Validator Codes)

### Errors (any = FAIL)

| Code | Check |
|------|-------|
| E001 | Frontmatter exists (starts/ends with `---`) |
| E002 | `name` field present |
| E003 | `description` field present |
| E004 | `name` matches folder name |
| E005 | H1 title exists |
| E006 | H1 matches title-case of `name` |
| E007 | `## When to Use This Skill` section exists |
| E008 | `## Prerequisites` section exists |
| E009 | `## Workflow` or `## Architecture` section exists |
| E010 | `## Edge Cases` section exists |
| E011 | `## Tools` or `## Tools Used` section exists |
| E012 | `## Examples` section exists |
| E013 | `## Success Criteria` section exists |

### Warnings (should fix)

| Code | Check |
|------|-------|
| W001 | Anti-triggers present ("Do NOT trigger when") |
| W002 | Prerequisites in table format |
| W003 | Edge Cases in table format |
| W004 | `### Triggering Prompts` subsection in Examples |
| W005 | `### Non-Triggering Prompts` subsection in Examples |
| W006 | Success Criteria uses numbered list |
| W007 | Description ends with trigger hint |
| W008 | File is 100-800 lines |
| W009 | Required sections appear in schema order |

### Info (nice to fix)

| Code | Check |
|------|-------|
| I001 | Validation Checklist present (if produces artifacts) |
| I002 | Troubleshooting present (if external tools) |
| I003 | Tips present (if gotchas exist) |
| I004 | Reference file consistency (`references/` dir <-> `## Reference Files`) |
| I005 | Code blocks have language tags |

---

## 2. Declarative Compliance

| Check | How to Verify | Fix |
|-------|--------------|-----|
| No procedural commands in workflow | Workflow steps contain no bash/shell commands, no language-specific code | Rewrite step as: Goal + Acceptance criteria + Constraints |
| No tool assumptions | Workflow does not assume specific CLIs, languages, or package managers | Replace tool references with capability descriptions |
| Environment-agnostic | No OS-specific paths, commands, or assumptions | Use generic descriptions; mark platform-specific needs as optional |
| Non-built-in tools marked optional | Only Read/Write/Edit/Bash/Grep/Glob are assumed available | Move other tools to optional with fallback described |
| Success criteria are outcome-based | Criteria describe results ("report contains X") not process ("script executed") | Rewrite as assertions about outcomes |
| User tool preferences respected | If skill was created from user request for specific tool, it's noted as preference not requirement | Add "User preference:" annotation, keep declarative alternative |

---

## 3. CSO Quality (beyond validator)

| Check | How to Verify | Fix |
|-------|--------------|-----|
| Description front-loaded | First 250 chars contain primary use case | Rewrite: put use case first, details after |
| No workflow in description | Description does NOT describe steps/phases | Remove process words; describe only WHEN to use |
| Trigger hint present | Description ends with "Trigger when/with..." | Append trigger hint sentence |
| Third person voice | No "I", "you", "we" in description | Rewrite in third person |

---

## 4. Compaction Readiness

| Check | Target | How to Verify |
|-------|--------|--------------|
| Total lines | 100-500 | `wc -l SKILL.md` |
| Token budget | < 5,000 tokens | `wc -w SKILL.md` < ~3,750 words |
| SAFETY RULE position | First 20 lines (if present) | Check line number |
| Triggers position | First 40 lines | Check `## When to Use` line number |
| Core workflow | First 150 lines | Phase 1-3 should be in first half |
| Reference offloading | Heavy content in `references/` | Tables > 30 rows, format specs, API docs should be in supporting files |

---

## 5. Structural Compliance

| Check | Expected | Common Violation |
|-------|----------|------------------|
| Tools heading | `## Tools` | `## Tools Used` (v1 pattern) |
| Tool groupings | `**Built-in (required):**`, `**External CLI:**`, `**MCP Tools:**`, `**Agent:**` | Flat list without categories |
| `${CLAUDE_SKILL_DIR}` | Used for supporting file references | Hardcoded absolute paths |
| Phase/Step naming | `Phase N:` for 5+ steps, `Step N:` for fewer | Inconsistent naming |
| Anti-trigger redirects | Parenthetical redirect hints | Bare anti-triggers without suggesting alternatives |
| Edge case coverage | 8-20 rows minimum | < 8 rows or missing: tool unavail, ambiguous input, missing data |
| Success criteria | 10-20 numbered assertions | < 10 items or process descriptions instead of assertions |

---

## 6. Frontmatter Hygiene

| Check | How to Verify |
|-------|--------------|
| No unknown fields | All fields are in SKILL_SCHEMA v2.0 tables |
| `argument-hint` present if skill takes args | Check if `$ARGUMENTS` used in body |
| `allowed-tools` present if 3+ tools | Count tools in `## Tools` section |
| `disable-model-invocation` if destructive | Check for delete/archive/send side effects |
| SAFETY RULE if external side effects | Check for MCP writes, email, Slack posts |

---

## Audit Report Template

```markdown
## Skill Audit Report — <skill-name>

**File:** `.claude/skills/<name>/SKILL.md`
**Lines:** <count> | **Words:** <count> | **Est. Tokens:** <count * 1.33>

### Validator Result: PASS/FAIL
- Errors: N
- Warnings: N
- Info: N

### CSO Quality: GOOD/NEEDS WORK
- [ ] Description front-loaded
- [ ] No workflow in description
- [ ] Trigger hint present

### Compaction: READY/AT RISK
- [ ] Under 5,000 tokens
- [ ] Critical content in first 150 lines

### Structural Compliance: COMPLIANT/NEEDS UPDATE
- [ ] `## Tools` heading
- [ ] `${CLAUDE_SKILL_DIR}` used
- [ ] Phase/Step naming consistent

### Recommended Fixes
1. [Priority] Description of fix
2. [Priority] Description of fix
```
