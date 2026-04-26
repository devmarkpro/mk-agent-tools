---
name: mk-conventional-commits
description: >
  Writes git commit messages following the Conventional Commits specification.
  Guides type selection, scope choice, and description formatting for clean,
  parseable commit history. Trigger when writing any git commit message.
metadata:
  tags:
    - git
    - swe
    - devex
  author: devmarkpro
  version: "1.1.0"
---

# Mk Conventional Commits

Write git commit messages following the [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) specification. Produces clean, parseable commit history that works with automated tooling (changelogs, semantic versioning, release notes).

## When to Use This Skill

**Trigger when:**
- Writing a git commit message
- User asks to commit staged changes
- User asks to create or prepare a commit
- Reviewing or fixing a commit message
- User asks what type or scope to use for a commit

**Do NOT trigger when:**
- User asks about git workflow or branching (answer directly or use a git workflow skill)
- User asks to write a PR or MR description (not a commit message)
- User asks about changelog generation (not this skill)
- User asks to push, pull, or rebase (direct git operations)

## Prerequisites

| Requirement | Details |
|---|---|
| Staged changes | `git diff --cached` should show changes to commit |
| mk-humanizer | Optional — can validate description text for AI patterns |

---

## Commit Format

```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

## Workflow

### Step 1: Determine the type

**Goal:** Pick the type that best describes the nature of the change.

| Type | When to use |
|------|-------------|
| `feat` | New feature or user-facing capability |
| `fix` | Bug fix |
| `docs` | Documentation only (READMEs, docstrings, comments, guides) |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `test` | Adding or updating tests |
| `perf` | Performance improvement with no functional change |
| `build` | Build system or external dependency changes |
| `ci` | CI/CD pipeline changes |
| `chore` | Maintenance tasks that don't fit other types |
| `revert` | Reverting a previous commit |

If the change spans multiple types (e.g., a feature that also fixes a bug), pick the primary intent.

### Step 2: Choose the scope (recommended)

**Goal:** Narrow down what part of the codebase the commit touches.

Scope is optional per the spec but recommended for clarity. When included, it's parenthesized and lowercase.

**How to choose a scope:**
- Use the module, package, or component name the change is in
- Use the area of concern: `auth`, `api`, `config`, `db`, `cli`, `docs`
- Be consistent — review recent commit messages to identify established scope conventions in the repository

If a commit touches multiple areas, use the primary one. If genuinely cross-cutting, scope can be omitted.

### Step 3: Write the description

**Goal:** Summarize the change in one imperative-mood line.

**Rules:**
- Imperative mood: "add endpoint" not "added endpoint" or "adds endpoint"
- Lowercase first letter
- No trailing period
- The full subject line (`type(scope): description`) should be 72 characters or fewer — aim for 50

**Good descriptions focus on what changed and why it matters, not implementation details:**
- "add retry logic for payment webhook" — clear
- "update code" — too vague
- "refactor the handlePayment function to use async/await instead of callbacks and also fix the error handling" — too detailed for a subject line; put this in the body

### Step 4: Add breaking change marker if needed

**Goal:** Signal that this commit introduces a breaking change to a public API or interface.

Mark with `!` before the colon:

```
feat(api)!: change authentication to OAuth 2.0
```

If breaking, the body should explain what breaks and how to migrate.

### Step 5: Write body and footers (optional)

**Body:**
- Separate from subject with a blank line
- Wrap at 72 characters per line
- Explain what and why, not how — the diff shows the how

**Footers:**
- `BREAKING CHANGE: <description>` — alternative to `!` marker
- `Refs: #123` or `Closes: #456` — link to issues
- `Co-authored-by:` and `Signed-off-by:` are common in open source
- Footer format: `<token>: <value>` or `<token> #<value>`

### Step 6: Check for common mistakes

**Goal:** Catch formatting errors before committing.

| Mistake | Example | Fix |
|---------|---------|-----|
| No type prefix | "Update the endpoint" | Add type: `feat(api): add endpoint` |
| Capitalized description | `feat(api): Add endpoint` | Lowercase: `feat(api): add endpoint` |
| Past tense | `feat(api): added endpoint` | Imperative: `feat(api): add endpoint` |
| Trailing period | `fix(db): handle null.` | Remove period |
| Invented type | `update(api): ...` | Use a standard type from the table |
| Vague description | `fix: stuff` | Be specific: `fix(auth): handle expired token refresh` |
| Subject too long | 80+ characters | Shorten description, move details to body |

---

## Edge Cases

| Situation | Handling |
|-----------|----------|
| Commit touches multiple areas | Use the primary scope, or omit scope if genuinely cross-cutting |
| Subject line too long with type prefix | Shorten the description — the prefix counts toward the limit |
| No obvious scope | Omit it — scope is optional. Don't use "misc" or "general" |
| Quick one-line fix | Still use full format: `fix(scope): description` |
| Breaking change | Add `!` before colon OR use `BREAKING CHANGE:` footer; explain migration in body |
| Reverting a commit | `revert: <original subject>` with body referencing the reverted SHA |
| Initial commit | `chore: initial project setup` is fine |
| Merge commits | Leave merge commit messages as-is (auto-generated by git) |
| Multiple logical changes in one commit | Split into separate commits, each with its own type and scope |

## Tools

**Built-in:**
- Bash — running git commands

**Agent (optional):**
- mk-humanizer — validate description text for AI patterns

## Examples

### Triggering Prompts
- `commit these changes`
- `write a commit message for the staged files`
- `git commit`
- `create a commit for the auth changes`
- `fix my commit message`
- `what type should I use for this commit?`

### Non-Triggering Prompts
- `write a PR description` (not a commit message)
- `what's the branching strategy?` (answer directly)
- `generate a changelog` (not this skill)
- `push my changes` (direct git operation)

### Commit Message Examples

Simple feature:
```
feat(auth): add OAuth 2.0 login flow
```

Bug fix with body:
```
fix(parser): handle empty input without panic

The CSV parser crashed on empty files because the header reader
assumed at least one row existed. Now returns an empty result set.

Closes: #142
```

Dependency update:
```
build(deps): bump express to 4.21.0
```

Breaking change:
```
feat(api)!: require API key for all endpoints

BREAKING CHANGE: All endpoints now require an X-API-Key header.
Unauthenticated requests return 401 instead of serving public data.
Migration: generate a key at /settings/api-keys and pass it in
the X-API-Key header.
```

CI change:
```
ci: add test coverage reporting to PR checks
```

Documentation:
```
docs(readme): add setup instructions for local development
```

Performance:
```
perf(search): add index on created_at for query optimization
```

Revert:
```
revert: feat(auth): add OAuth 2.0 login flow

Reverts commit a]1b2c3d. The OAuth provider has an outage and
we need to restore password-based login while it's resolved.
```

## Success Criteria

1. Every commit message starts with a valid type from the standard set
2. Scope, when present, is lowercase and specific to the area changed
3. Description uses imperative mood with a lowercase first letter
4. No trailing period on the subject line
5. Subject line is 72 characters or fewer
6. Breaking changes are marked with `!` or a `BREAKING CHANGE:` footer
7. Body (if present) is separated by a blank line and wrapped at 72 characters
8. Footers follow the `<token>: <value>` format
9. The message is parseable by standard conventional commit tooling
10. The commit type is from the standard set — no invented types

## Tips

1. **"50 or 72 characters?"** — Aim for 50 on the subject line. Hard limit at 72. The type prefix and scope eat into this budget.
2. **"Scope feels redundant with the diff"** — It's for humans scanning `git log --oneline`, where there is no diff.
3. **"This commit does too many things"** — Split it. One logical change per commit.
4. **"Can I use a custom type?"** — The spec allows it, but stick to the standard set for tooling compatibility.
