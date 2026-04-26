---
name: dmp-skill-creator
description: >
  Dual-mode skill factory: creates new skills from natural language or audits
  existing skills against SKILL_SCHEMA v2.0. Session-aware — extracts context
  from ongoing conversations or guides discovery from scratch. Produces
  declarative, compaction-aware, environment-agnostic SKILL.md files.
  Trigger when user asks to create, build, scaffold, review, or audit a skill.
argument-hint: "[create <description> | review <skill-name>]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Agent
metadata:
  tags:
    - swe
    - tooling
    - devex
    - planning
  author: devmarkpro
  version: "3.0.0"
---

# Skill Creator

The ROOT skill for skill authoring. Operates in two modes: **Create** (draft new skills from natural language or session context) and **Review** (audit existing skills against SKILL_SCHEMA v2.0). Session-aware — when invoked mid-conversation, extracts the workflow the user just performed and proposes a skill to automate it.

## When to Use This Skill

**Trigger when:**
- User says `/dmp-skill-creator`, "create a new skill", "build a skill", "scaffold a skill"
- User says `/dmp-skill-creator create <description>`
- User describes automation and wants it packaged as a skill
- After a work session, user says "make this a skill", "automate this process", "I want a skill for what we just did"
- User says `/dmp-skill-creator review <name>`, "audit the X skill", "check if skill X follows the schema"

**Do NOT trigger when:**
- User wants to make a small edit to an existing skill (edit directly with Read/Edit)
- User asks how skills work conceptually (answer directly)
- User wants to create an agent, not a skill (agents go in `.claude/agents/`)
- User wants to list, rename, or delete skills (use Bash directly)

## Prerequisites

| Requirement | Details |
|---|---|
| SKILL_SCHEMA v2.0 | `${CLAUDE_SKILL_DIR}/references/SKILL_SCHEMA.md` must exist |
| Skeleton template | `${CLAUDE_SKILL_DIR}/references/skill-skeleton.md` |
| Existing skills | At least 1 skill in `.claude/skills/` for structural reference (optional — use skeleton if none) |
| Skill validator agent | `.claude/agents/skill-validator.md` (optional — skip automated validation if absent) |

---

## Design Philosophy

These three principles govern both this skill's own behavior AND the skills it produces. Violations should be caught during Review Mode and flagged at CHECKPOINT 3 during Create Mode.

### Principle 1: Declarative over Procedural — What/Why, not How

Skills describe **goals and acceptance criteria**, not step-by-step commands. The executing agent is intelligent — it can figure out the *how* using whatever tools and environment are available.

**Why:** A skill may run on macOS, Linux, or Windows. The user may have Python, Node, Ruby, or none of them. The agent has access to different MCP tools, CLIs, and built-in capabilities depending on the installation. Hardcoding commands makes skills brittle and environment-dependent.

| Instead of (procedural) | Write (declarative) |
|------------------------|---------------------|
| `python3 scripts/validate.py config.yml` | Validate the YAML configuration file for structural correctness |
| `grep -r "TODO" src/ \| wc -l` | Count all TODO comments across the source directory |
| `npm audit --json \| jq '.vulnerabilities'` | Scan project dependencies for known security vulnerabilities |
| `curl -s https://api.example.com/health` | Check that the service health endpoint responds successfully |

**How to apply:** Each workflow step should state the *goal* (what to achieve), the *acceptance criteria* (how to know it worked), and optionally *constraints* (what to avoid). Never prescribe specific tools, languages, or commands.

### Principle 2: Environment Agnosticism

Skills must not assume:
- A specific OS, shell, or package manager
- That any particular language runtime is installed
- That specific CLI tools exist beyond Claude Code built-ins (Read, Write, Edit, Bash, Grep, Glob)
- That specific MCP tools are available

When a skill needs external capabilities, describe the *capability needed* and mark it optional with a fallback. Example: "If a YAML parser is available, use it for validation; otherwise, check structure manually."

### Principle 3: User Intent Empowerment

- If the user explicitly requests a specific tool or approach ("use Python to validate this"), **accommodate it** — the skill should note the user's preference and include it
- But also **suggest alternatives** when they exist: "You asked for Python — I'll include that. Note: the agent can also validate YAML using built-in tools, which would make the skill work without Python installed. Want me to make it tool-agnostic instead?"
- During discovery, actively propose better approaches when you see them. The goal is to empower the user to make informed decisions, not to silently comply or silently override
- When a produced skill could benefit from being more declarative, suggest it at CHECKPOINT 2

---

## Checkpoint Protocol

Every phase ends with a checkpoint. Checkpoints keep the user in control without overwhelming them.

**Format:**
```
CHECKPOINT N — [Phase Name]

[2-5 bullet summary of findings/decisions]

Next: [one sentence — what happens if user confirms]

→ Confirm, or redirect me.
```

**Rules:**
- Never skip a checkpoint — user confirmation is required before the next phase
- Keep each checkpoint to 2-5 bullets. If you need more, you haven't synthesized enough.
- If user says "looks good" / "yes" / "continue" → proceed to next phase
- If user corrects or redirects → incorporate feedback, re-present the same checkpoint
- If user asks a question → answer it, then re-present the checkpoint

---

## Workflow — Create Mode

### Phase 0: Context Detection

Determine how the skill request arrived:

**Scenario A — Existing session context:**
The user has been working in this session (files edited, tools run, multi-turn conversation) and now asks to turn that work into a skill. Signals: "automate this", "make this a skill", "skill for what we just did", or the request references work done earlier in conversation.

**Scenario B — Clean start:**
The user opened a fresh session or the request has no relationship to prior conversation. Signals: `/dmp-skill-creator create <description>`, or the request is self-contained.

**Detection:**
1. Does the user's request reference prior conversation work? → Scenario A
2. Does the conversation contain substantial prior tool use or multi-step work? → Scenario A
3. Otherwise → Scenario B

Branch accordingly to Phase 1A or Phase 1B.

Also detect mode: if the request contains `review` or `audit` for an existing skill → branch to **Review Mode** (Phase R1).

### Phase 1A: Session Context Extraction (Scenario A only)

Mine the current conversation to build a picture of what the user was doing:

**Extract:**
- **Goal:** What was the user trying to accomplish?
- **Steps:** What sequence of actions did they take?
- **Tools used:** Which built-in tools, CLIs, MCP tools, or agents were involved?
- **Inputs:** What data did the workflow consume?
- **Outputs:** What did the workflow produce?
- **Pain points:** What was manual, repetitive, or error-prone?
- **Decisions:** What judgment calls did the user make that could be codified?

**Important:** Extract the *goals* of each step, not the specific commands used. The session may have used Python, but the skill should describe the goal achieved, not prescribe Python. If the user explicitly chose a specific tool for a reason, note that reason.

**Do NOT:**
- Assume the entire session should become one skill — look for the repeatable core
- Copy procedural commands from the session into the skill — abstract to goals
- Guess at parts you didn't observe — flag gaps instead

**→ CHECKPOINT 1A:**
Present the extracted workflow summary. Example:
```
CHECKPOINT 1 — Session Analysis

- You were [goal], working with [inputs]
- The workflow was: [3-5 goal-oriented step summary]
- Capabilities needed: [what the skill needs to be able to do]
- The repeatable part seems to be: [core workflow]
- Gap: I'm not sure about [specific uncertainty]

Next: I'll explore whether this is the right shape for a skill and fill in gaps.

→ Confirm this captures it, or correct me.
```

### Phase 1B: Discovery (Scenario B, or after 1A to fill gaps)

Understand the *problem* before defining the *solution*. Do NOT jump to requirements.

**1B.1 Understand the problem:**
Ask (or extract from user description — do not ask what's already clear):
- What problem does this solve? What's painful or repetitive today?
- Who invokes this — the user directly, or should Claude auto-detect the need?
- What does "done" look like? What's the output or end state?

**1B.2 Validate the approach:**
- Is a skill the right solution? (vs. an agent for background work, a hook for automated triggers, or a plain script)
- Does an existing skill already handle this? Check existing skills in `.claude/skills/` for trigger overlap.
- Is this one skill or should it be split into multiple?

**1B.3 Scope the skill:**
- What's the minimum viable workflow?
- What are stretch goals vs. core functionality?

**1B.4 Suggest improvements:**
If you see opportunities to make the skill more portable, simpler, or more powerful, suggest them here. Examples:
- "You mentioned using jq for parsing — if we describe the goal instead, the skill works even without jq installed"
- "This could be two simpler skills instead of one complex one"
- "Adding an argument for the output format would make this more flexible"

**→ CHECKPOINT 1B:**
```
CHECKPOINT 1 — Discovery

- Problem: [one sentence]
- Proposed solution: A skill that [one sentence]
- Why a skill (not agent/hook/script): [reason]
- Core scope: [2-3 bullets — minimum viable workflow]
- Suggestions: [improvements, or "none"]

Next: I'll define the detailed requirements — name, triggers, inputs, outputs.

→ Confirm this direction, or redirect me.
```

### Phase 2: Requirements Definition

Now that the problem and approach are confirmed, define the skill specification.

**2.1** Define structured requirements:

| Aspect | Source |
|--------|--------|
| Purpose | From Phase 1 discovery/extraction |
| Name | Derive kebab-case name from purpose |
| Triggers | How would a user invoke this? (3-5 natural language + slash command) |
| Inputs | What data does it need? |
| Outputs | What does it produce? |
| Capabilities needed | What must the executing agent be able to do? (NOT which specific tools) |

**2.2** Determine skill characteristics for frontmatter:

| Question | If YES |
|----------|--------|
| External side effects? | Add SAFETY RULE |
| Accepts arguments? | Add `argument-hint` |
| Should Claude never auto-invoke? | Set `disable-model-invocation: true` |
| Uses 3+ built-in tools consistently? | Add `allowed-tools` |
| Self-contained pipeline? | Set `context: fork` + `agent:` |

Read `${CLAUDE_SKILL_DIR}/references/frontmatter-reference.md` for the full field decision guide.

**2.3** Check: if the user requested specific tools, note them as preferences. Flag where the skill could be more environment-agnostic and suggest it. Respect the user's final decision.

**2.4** Determine complexity tier:

| Tier | Steps | Heading Style |
|------|-------|--------------|
| Simple | 3-4 | `Step N:` |
| Medium | 5-7 | `Phase N:` |
| Complex | 8+ | `Phase N:` with sub-steps |
| Multi-mode | Any | `Phase N:` per mode |

**→ CHECKPOINT 2:**
```
CHECKPOINT 2 — Skill Spec

- Name: `<name>`
- Purpose: [one sentence]
- Triggers: [slash command + 2-3 natural language variants]
- Workflow outline: [numbered goal-oriented steps, one line each]
- Capabilities: [what the agent needs to do, not which tools]
- Special: [SAFETY RULE / argument-hint / context:fork — or "none"]
- [If applicable: "You asked for X — I've included it. Note: making this tool-agnostic would improve portability."]

Next: I'll read the schema and draft the full SKILL.md.

→ Confirm this spec, or adjust.
```

### Phase 3: Draft SKILL.md

**3.1** Read the schema and skeleton template from `${CLAUDE_SKILL_DIR}/references/`.

**3.2** Find existing skills matching the complexity tier for structural reference.

**3.3** Generate the complete SKILL.md. Key authoring rules:

- **Frontmatter:** All applicable fields from Phase 2. `description` is CSO-optimized — first 250 chars = primary use case, end with "Trigger when/with...", NEVER summarize the workflow.
- **H1 Title:** Title Case of `name` + 1-2 sentence summary.
- **SAFETY RULE** (conditional): Only when Phase 2 identified external side effects.
- **When to Use:** Triggers + anti-triggers with parenthetical redirects.
- **Prerequisites:** Table format. List *capabilities needed*, not specific tool versions. Mark optional items.
- **Workflow:** Each step states: the **goal** (what to achieve), the **acceptance criteria** (how to know it worked), and optionally **constraints** (what to avoid). Never prescribe specific tools or commands.
- **Edge Cases:** Table, 8-20 rows. MUST cover: missing data, tool unavailability, ambiguous input.
- **Tools:** Heading `## Tools`. Group: `Built-in (required)`, `External CLI (optional)`, `MCP Tools (optional)`, `Agent`. Mark everything beyond Read/Write/Edit/Bash/Grep/Glob as optional.
- **Examples:** 5-8 triggering + 4-6 non-triggering with redirect hints.
- **Success Criteria:** 10-20 numbered testable assertions focused on outcomes, not process.

**3.4 Declarative quality check** before writing:
- Does any workflow step prescribe a specific command, language, or tool? → Rewrite as a goal
- Does any step assume a specific OS or package manager? → Make environment-agnostic
- If user requested a specific tool: is it noted as a preference, not a requirement?
- Are success criteria about outcomes ("report contains X") not process ("Python script ran")?

**3.5 Compaction check** before writing:
- SAFETY RULE + triggers in first ~40 lines
- Core workflow in first ~150 lines
- Total: 100-500 lines, under ~3,750 words
- Offload heavy reference material to `references/`
- Use `${CLAUDE_SKILL_DIR}` for all supporting file references

**3.6** Write the skill files.

**→ CHECKPOINT 3:**
```
CHECKPOINT 3 — Draft Complete

- File: `.claude/skills/<name>/SKILL.md` ([N] lines, [N] words)
- Sections: [list of H2 headings present]
- Declarative check: [PASS — no procedural commands / NEEDS WORK — specific issues]
- SAFETY RULE: [included / not needed]
- Supporting files: [list, or "none"]
- Compaction: [SAFE — critical content in first N lines]

Next: I'll validate against the schema and run quality checks.

→ Review the file, then confirm. Or point out issues to fix first.
```

### Phase 4: Validate (max 3 iterations)

**4.1** If a skill-validator agent exists at `.claude/agents/skill-validator.md`, invoke it. Otherwise, validate manually against SKILL_SCHEMA.md — check required sections, frontmatter fields, formatting rules, and declarative compliance.

**4.2** Parse the result:
- **PASS** (0 errors): proceed
- **FAIL**: apply fixes, re-validate. Maximum 3 iterations.

**4.3** Additional quality checks:
- Word count: verify under ~3,750 words
- Trigger conflict check against existing skills
- Reference consistency: supporting directories match `## Reference Files` section
- **Declarative compliance**: no procedural commands leaked into workflow steps

**→ CHECKPOINT 4:**
```
CHECKPOINT 4 — Validation

- Schema validation: PASS/FAIL ([N] errors, [N] warnings)
- Declarative compliance: PASS/FAIL
- Token budget: [N] words ([within/over] limit)
- Trigger conflicts: [none / list]

Next: I'll generate test scenarios, then present for final approval.

→ Confirm, or flag issues.
```

### Phase 5: Simulated Conversation Test

Generate 3 test scenarios:

| # | Type | What to Check |
|---|------|---------------|
| 1 | Triggering prompt | Skill activates, correct workflow fires, expected output |
| 2 | Non-triggering prompt | Skill does NOT activate, correct redirect suggested |
| 3 | Edge case | Ambiguous/missing input, graceful handling per Edge Cases table |

### Phase 6: Final Review

Present to the user:
1. Skill summary (name, purpose, trigger, file location)
2. Validation: PASS
3. Simulation results table (3 rows)
4. **Approve, Edit, or Reject?**

### Phase 7: Finalize

If **approved**: confirm file location, suggest CLAUDE.md update if appropriate.
If **edit requested**: apply edits → re-validate (Phase 4) → re-present (Phase 6).

---

## Workflow — Review Mode

### Phase R1: Load Target Skill

Parse skill name from arguments. Find the matching SKILL.md in `.claude/skills/`. Read it and the schema.

### Phase R2: Automated Audit

**R2.1** If a skill-validator agent exists, run it. Otherwise, validate manually against the schema.

**R2.2** Run additional checks. Read `${CLAUDE_SKILL_DIR}/references/review-checklist.md` for the full checklist. Key checks:

| Category | Checks |
|----------|--------|
| **Declarative** | Workflow steps describe goals, not commands? No hardcoded tools/languages? Environment-agnostic? |
| **CSO Quality** | Description front-loaded? No workflow summary? Trigger hint present? |
| **Compaction** | Under 5,000 tokens? Critical content in first 150 lines? |
| **Frontmatter** | No unknown fields? Missing recommended fields? |
| **Structure** | `## Tools` heading? `${CLAUDE_SKILL_DIR}` used? Phase/Step naming consistent? |
| **References** | `## Reference Files` matches actual subdirectories? |

### Phase R3: Report and Remediate

Present a structured audit report:
1. Validator result (PASS/FAIL)
2. **Declarative compliance** (procedural patterns found, with rewrites)
3. CSO quality assessment
4. Compaction readiness
5. Structural compliance
6. Specific fix suggestions

Ask: **Should I apply the fixes?**

If yes: apply fixes → re-validate → re-present report.

---

## Edge Cases

| Situation | Handling |
|-----------|----------|
| Skill name conflicts with existing skill | Show existing skill, ask user to rename or update existing |
| Trigger phrases overlap with existing skill | Flag overlap, require user to disambiguate before proceeding |
| User description too vague | Enter Discovery (Phase 1B) to explore the problem space |
| Session context is ambiguous (multiple workflows) | Ask user which part of the session to capture |
| Session had debugging/tangents mixed in | Extract only the repeatable core, flag what was excluded |
| User explicitly requests a specific tool | Accommodate the preference, suggest declarative alternative, respect user's choice |
| Produced skill contains procedural commands | Flag at CHECKPOINT 3 declarative check, rewrite as goals |
| Validation fails 3 times | Show remaining errors, ask user to manually fix or adjust requirements |
| User wants an agent, not a skill | Explain difference, offer to create agent instead |
| Skill would exceed 500 lines | Offload reference material to `references/` subdirectory |
| No existing skills for reference | Use schema + skeleton template as structural guide |
| Schema file missing | Abort with clear error — schema is the source of truth |
| Review mode: skill path not found | Search by partial name, offer closest matches |
| User asks to create a skill that exists | Offer to review/update existing or create with different name |
| User confirms checkpoint but adds caveats | Incorporate the caveat, re-present same checkpoint |
| User skips ahead ("just write it") | Warn that skipping discovery risks a poor skill, but comply if user insists |

## Tools

**Built-in (required):**
- Read — reading schema, reference skills, session context, drafts
- Write — creating SKILL.md and reference files
- Edit — applying validation fixes and declarative rewrites
- Grep — finding trigger conflicts, scanning existing skills
- Glob — finding existing skills
- Bash — directory creation, file operations

**Agent (optional):**
- skill-validator — automated validation in Phase 4 and Phase R2 (if `.claude/agents/skill-validator.md` exists)

## Examples

### Triggering Prompts
- `/dmp-skill-creator`
- `/dmp-skill-creator create weekly email summarizer`
- `Create a new skill for weekly status reports`
- `Build a skill that processes API responses into reports`
- `I want a skill that generates meeting prep briefings from my calendar`
- `Can we turn what we just did into a skill?`
- `I want to automate this process as a skill`
- `/dmp-skill-creator review my-skill-name`
- `Audit my data-pipeline skill`

### Non-Triggering Prompts
- `Edit the deploy skill to add a new phase` (edit directly with Read/Edit)
- `How do skills work in Claude Code?` (answer conceptually)
- `Create an agent for health checks` (create agent in `.claude/agents/`)
- `Delete the old morning-briefing skill` (use Bash directly)
- `List all my skills` (use Glob or Bash directly)

## Success Criteria

1. Session context is correctly detected (Scenario A vs B)
2. When session context exists, extracted workflow captures goals not commands
3. Discovery phase explores the problem before defining the solution
4. Every phase ends with a checkpoint that the user confirms
5. Checkpoints are 2-5 bullets — concise, not overwhelming
6. User feedback at checkpoints is incorporated before proceeding
7. When user requests a specific tool, it is accommodated with alternatives suggested
8. Produced skill workflow steps describe goals and acceptance criteria, not commands
9. Produced skill makes no assumptions about OS, language runtime, or CLI availability
10. Produced skill marks all non-built-in tools as optional
11. SKILL.md is created at `.claude/skills/<name>/SKILL.md`
12. Folder name matches `name` frontmatter field exactly
13. Description is CSO-optimized: first 250 chars = primary use case, ends with trigger hint
14. All required sections are present in schema v2.0 order
15. SAFETY RULE is included when skill has external side effects
16. No trigger overlap with existing skills
17. SKILL.md is 100-500 lines and under ~3,750 words
18. Critical content in the first 150 lines
19. User approves the final output

## Reference Files

| File | Purpose |
|------|---------|
| `references/SKILL_SCHEMA.md` | The v2.0 schema — source of truth for all structural validation |
| `references/skill-skeleton.md` | Annotated SKILL.md template with all v2.0 sections and compaction guidance |
| `references/frontmatter-reference.md` | Full frontmatter field guide with decision trees and CSO rules |
| `references/review-checklist.md` | Structured audit checklist for review mode |
| `examples/create-session.md` | Worked example: creating a skill through all phases |
