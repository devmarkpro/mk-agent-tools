# Design Philosophy

These three principles govern both this skill's own behavior AND the skills it produces. Violations should be caught during Review Mode and flagged at CHECKPOINT 3 during Create Mode.

## Principle 1: Declarative over Procedural — What/Why, not How

Skills describe **goals and acceptance criteria**, not step-by-step commands. The executing agent is intelligent — it can figure out the *how* using whatever tools and environment are available.

**Why:** A skill may run on macOS, Linux, or Windows. The user may have Python, Node, Ruby, or none of them. The agent has access to different MCP tools, CLIs, and built-in capabilities depending on the installation. Hardcoding commands makes skills brittle and environment-dependent.

| Instead of (procedural) | Write (declarative) |
|------------------------|---------------------|
| `python3 scripts/validate.py config.yml` | Validate the YAML configuration file for structural correctness |
| `grep -r "TODO" src/ \| wc -l` | Count all TODO comments across the source directory |
| `npm audit --json \| jq '.vulnerabilities'` | Scan project dependencies for known security vulnerabilities |
| `curl -s https://api.example.com/health` | Check that the service health endpoint responds successfully |

**How to apply:** Each workflow step should state the *goal* (what to achieve), the *acceptance criteria* (how to know it worked), and optionally *constraints* (what to avoid). Never prescribe specific tools, languages, or commands.

## Principle 2: Environment Agnosticism

Skills must not assume:
- A specific OS, shell, or package manager
- That any particular language runtime is installed
- That specific CLI tools exist beyond Claude Code built-ins (Read, Write, Edit, Bash, Grep, Glob)
- That specific MCP tools are available

When a skill needs external capabilities, describe the *capability needed* and mark it optional with a fallback. Example: "If a YAML parser is available, use it for validation; otherwise, check structure manually."

## Principle 3: User Intent Empowerment

- If the user explicitly requests a specific tool or approach ("use Python to validate this"), **accommodate it** — the skill should note the user's preference and include it
- But also **suggest alternatives** when they exist: "You asked for Python — I'll include that. Note: the agent can also validate YAML using built-in tools, which would make the skill work without Python installed. Want me to make it tool-agnostic instead?"
- During discovery, actively propose better approaches when you see them. The goal is to empower the user to make informed decisions, not to silently comply or silently override
- When a produced skill could benefit from being more declarative, suggest it at CHECKPOINT 2

## Checkpoint Protocol

Every phase ends with a checkpoint. Checkpoints keep the user in control without overwhelming them.

**Format:**
```text
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
