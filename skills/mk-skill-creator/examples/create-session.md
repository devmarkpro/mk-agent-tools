# Worked Example: Creating a Dependency Audit Skill

Shows the skill-creator workflow with checkpoints. This example uses **Scenario B** (clean session start).

---

## User Input

```
User: Create a skill that audits project dependencies — outdated packages, security vulnerabilities, unused deps
```

## Phase 0: Context Detection

No prior session work detected. Self-contained request → **Scenario B (Clean start)**.
No `review`/`audit` keyword for an existing skill → **Create Mode**.

## Phase 1B: Discovery

**Extracted from user description:**
- Problem: Manual dependency audits are tedious and easy to forget
- Output: A structured report with severity levels
- Scope: Outdated packages + vulnerabilities + unused deps

**Approach validation:**
- Skill is the right solution (user-invoked, produces a report, no background work needed)
- No existing skills overlap with dependency auditing
- One skill, not multiple (all three checks are part of one audit workflow)

**CHECKPOINT 1:**
```
CHECKPOINT 1 — Discovery

- Problem: Dependency audits are manual and easy to skip
- Proposed solution: A skill that scans package manifests for outdated, vulnerable, and unused deps
- Why a skill: User-invoked workflow with structured output — not a background task
- Core scope: detect package manager, check outdated, scan vulnerabilities, find unused, generate report
- Stretch: auto-fix outdated deps (later, via --fix flag)
- No conflicts with existing skills

Next: I'll define the detailed spec — name, triggers, tools, workflow outline.

→ Confirm this direction, or redirect me.
```

**User:** Looks good, continue.

## Phase 2: Requirements Definition

| Aspect | Value |
|--------|-------|
| Name | `dep-audit` |
| Purpose | Audit project dependencies for outdated packages, vulnerabilities, and unused deps |
| Triggers | `/dep-audit`, "check dependencies", "audit packages", "are my deps up to date?" |
| Inputs | Package manifest files (package.json, pyproject.toml, go.mod, etc.) |
| Outputs | Structured audit report with severity levels (Critical/Warning/Info) |
| Capabilities | Detect package manager type, check for outdated packages, scan for known vulnerabilities, identify unused dependencies |

**Characteristics:**
- External side effects? **No** → no SAFETY RULE
- Accepts arguments? **Yes** (`--fix`) → add `argument-hint`
- Auto-invoke? **Yes** → default
- Complexity: Medium (5 phases) → use `Phase N:` naming

**CHECKPOINT 2:**
```
CHECKPOINT 2 — Skill Spec

- Name: `dep-audit`
- Purpose: Audit dependencies for outdated, vulnerable, and unused packages
- Triggers: `/dep-audit`, "check dependencies", "audit packages"
- Workflow: 5 goal-oriented phases — detect package manager → check outdated → scan vulns → find unused → generate report
- Capabilities: package manager detection, version comparison, vulnerability lookup, unused dependency analysis
- Special: `argument-hint: "[--fix]"` for auto-fix mode

Next: I'll read the schema and draft the full SKILL.md.

→ Confirm this spec, or adjust.
```

**User:** Yes, go ahead.

## Phase 3: Draft SKILL.md

- Read SKILL_SCHEMA v2.0 and skeleton template
- Referenced an existing medium-complexity skill for structural guidance
- Generated SKILL.md (178 lines, ~1,350 words) with declarative workflow:

```
# Dep Audit
## When to Use This Skill                       <- triggers + 4 anti-triggers
## Prerequisites                                <- capabilities needed, not tool versions
## Workflow                                      <- 5 goal-oriented phases
  ### Phase 1: Detect Package Manager
    Goal: Identify which package manager(s) the project uses
    Acceptance: Package manager type and manifest file path(s) identified
  ### Phase 2: Check Outdated
    Goal: Compare installed dependency versions against latest available
    Acceptance: List of outdated packages with current vs latest version
  ### Phase 3: Scan Vulnerabilities
    Goal: Check dependencies against known vulnerability databases
    Acceptance: List of vulnerable packages with severity and advisory links
  ### Phase 4: Find Unused
    Goal: Identify dependencies declared but not imported in source code
    Acceptance: List of unused dependencies with confidence level
  ### Phase 5: Generate Report
    Goal: Produce structured audit report combining all findings
    Acceptance: Report with severity-sorted findings (Critical/Warning/Info)
## Edge Cases                                   <- 10 rows
## Tools                                        <- grouped by category
## Examples                                     <- 6 triggering, 4 non-triggering
## Success Criteria                             <- 12 outcome-based assertions
```

**CHECKPOINT 3:**
```
CHECKPOINT 3 — Draft Complete

- File: `.claude/skills/dep-audit/SKILL.md` (178 lines, 1350 words)
- Sections: When to Use, Prerequisites, Workflow (5 phases), Edge Cases (10), Tools, Examples (6+4), Success Criteria (12)
- Declarative check: PASS — all workflow steps describe goals, no hardcoded commands
- SAFETY RULE: not needed
- Compaction: SAFE — triggers at line 14, core workflow starts at line 40

Next: I'll validate against the schema.

→ Review the file, then confirm.
```

**User:** Looks good.

## Phase 4: Validate

```
Skill Validation Report — dep-audit

Errors (0)
Warnings (0)
Info (1)
- [I002] No Troubleshooting section (acceptable — uses only built-in tools)

Result: PASS
```

**CHECKPOINT 4:**
```
CHECKPOINT 4 — Validation

- Schema validation: PASS (0 errors, 0 warnings, 1 info)
- Token budget: 1,350 words (within limit)
- Trigger conflicts: none

Next: I'll run test scenarios, then present for final approval.

→ Confirm.
```

## Phase 5: Simulated Conversation Test

| # | Type | Input | Expected | Verdict |
|---|------|-------|----------|---------|
| 1 | Triggering | `/dep-audit` | Skill activates, runs 5 phases, produces report | PASS |
| 2 | Non-triggering | "Install a new package" | Does NOT activate, suggests Bash | PASS |
| 3 | Edge case | `/dep-audit` with no manifests | "No package manifests found", exits gracefully | PASS |

## Phase 6: Final Review

```
Skill: dep-audit
Purpose: Audit project dependencies for outdated, vulnerable, and unused packages
Trigger: /dep-audit
File: .claude/skills/dep-audit/SKILL.md (178 lines)
Validation: PASS
Tests: 3/3 passed

→ Approve, Edit, or Reject?
```

**User:** Approve.

## Phase 7: Finalize

```
Created:
  .claude/skills/dep-audit/
    SKILL.md (178 lines, ~1,350 words)

No reference files needed.
No CLAUDE.md update suggested.
```

---

# Worked Example: Session Context Extraction (Scenario A)

Shows how the skill-creator handles a request after an existing work session.

## Session Context

The user spent the past 20 minutes in this session:
1. Read a CSV file of customer feedback
2. Used Bash to run a Python script that categorized sentiment
3. Edited a markdown report template
4. Wrote categorized results into the template
5. Then said: "Can we turn this into a skill?"

## Phase 0: Context Detection

User references "this" — prior conversation work exists → **Scenario A**.

## Phase 1A: Session Context Extraction

**Extracted from conversation:**
- **Goal:** Categorize customer feedback and generate a structured report
- **Steps:** Read CSV → run sentiment analysis (Python) → fill report template → write output
- **Tools:** Read (CSV + template), Bash (Python script), Write (final report)
- **Inputs:** CSV file, report template, Python sentiment script
- **Outputs:** Markdown report with categorized feedback
- **Pain points:** Manual template filling, remembering the correct Python command
- **Decisions:** Used 3 sentiment categories (positive/neutral/negative)

**CHECKPOINT 1A:**
```
CHECKPOINT 1 — Session Analysis

- You were categorizing customer feedback from a CSV into a structured report
- Workflow: read CSV → run sentiment analysis (Python) → fill markdown template → write report
- Tools: Read, Bash (python script), Write
- The repeatable part: the full pipeline from CSV input to report output
- Gap: should the sentiment categories be configurable, or always positive/neutral/negative?

Next: I'll explore scope and check if a skill is the right approach.

→ Confirm this captures it, or correct me.
```

**User:** Categories should be configurable. Otherwise spot on.

## Phase 1B: Discovery (filling gaps)

- Skill is right approach (user-triggered, structured pipeline)
- No existing skills overlap
- One skill, argument for CSV path, configurable categories

**CHECKPOINT 1B:**
```
CHECKPOINT 1 — Discovery

- Problem: Feedback categorization is a recurring manual process
- Solution: A skill that takes a CSV path, runs sentiment analysis, generates a report
- Categories are configurable (default: positive/neutral/negative)
- Core scope: CSV → sentiment → report

Next: I'll define the spec.

→ Confirm.
```

Workflow continues through Phases 2-7 with checkpoints at each stage.
