# ADR Template — Michael Nygard Format

This is the mandatory ADR template. Every ADR must follow this exact structure. No sections may be added, removed, or renamed.

**Source:** [Decision record template by Michael Nygard](https://github.com/joelparkerhenderson/architecture-decision-record/tree/main/locales/en/templates/decision-record-template-by-michael-nygard)

## Template

```markdown
# <NUMBER>. <TITLE>

Date: <YYYY-MM-DD>

## Status

<STATUS>

## Context

<CONTEXT>

## Decision

<DECISION>

## Consequences

<CONSEQUENCES>
```

## Field Descriptions

### Title

A short noun phrase that describes the decision. The number prefix matches the filename.

**Format:** `# <number>. <Short descriptive title>`

**Examples:**
- `# 2. Use PostgreSQL for persistent storage`
- `# 5. Adopt event-driven architecture for inter-service communication`
- `# 8. Use JWT for API authentication`

**Anti-patterns:**
- Too vague: `# 3. Database decision`
- Too verbose: `# 3. We decided to use PostgreSQL version 15 as our primary relational database management system`
- Not a noun phrase: `# 3. Should we use Redis?`

### Date

The date the ADR was created or last updated, in `YYYY-MM-DD` format.

### Status

The current state of the decision. Must be one of:

- **Proposed** — The decision is being discussed and has not yet been agreed upon.
- **Accepted** — The decision has been agreed upon and is active.
- **Deprecated** — The decision is no longer relevant or applicable, kept for history.
- **Superseded by [ADR-NNNN](NNNN-title.md)** — This decision has been replaced by a newer ADR. Include a Markdown link to the superseding ADR.

Additional link lines may appear under the status when ADRs are linked:
```
Accepted

Amends [3. Use Redis for caching](0003-use-redis-for-caching.md)
```

### Context

Describes the forces at play: the technical, business, social, or project conditions that make this decision necessary. This section should be factual and neutral — it sets the stage but does not argue for or against a particular option.

**Include:**
- What problem or need prompted this decision
- What constraints exist (technical, business, regulatory, timeline)
- What alternatives were considered (briefly — not a full analysis)
- Relevant context about the current system state

**Tone:** Neutral, descriptive. Use present tense to describe the current state and forces.

**Example:**
```
Our API currently uses synchronous request-response patterns. As the number of
downstream services grows, response times increase linearly. We need a way to
handle long-running operations without blocking the HTTP response.

Options considered include: polling, webhooks, server-sent events (SSE), and
WebSockets. Our clients are primarily server-to-server integrations that already
support HTTP callbacks.
```

### Decision

States what was decided. This section should be direct and authoritative.

**Format:** Active voice, present tense. Start with "We will..." or similar declarative phrasing.

**Example:**
```
We will use webhooks for asynchronous operation notifications. Each API consumer
will register a callback URL. When a long-running operation completes, the system
will POST the result to the registered URL with a signed payload.
```

**Anti-patterns:**
- Passive voice: "It was decided that webhooks would be used..."
- Conditional: "We might use webhooks if the team agrees..."
- Too much justification here (that belongs in Context)

### Consequences

Describes what becomes easier, harder, or different as a result of this decision. Include both positive and negative outcomes. This section should be honest about trade-offs.

**Structure:** List or prose describing:
- What becomes easier or better
- What becomes harder or worse
- What new constraints or requirements this creates
- Any follow-up actions needed

**Example:**
```
Consumers get near-real-time notifications without polling overhead.

We must now implement webhook delivery infrastructure: retry logic with
exponential backoff, delivery logging, and a dead-letter mechanism for
failed deliveries.

Consumers must expose a publicly reachable HTTPS endpoint, which may be
a barrier for some internal tools running behind firewalls.

We will need to add webhook signature verification documentation to the
API guide.
```

## Complete Example

```markdown
# 2. Use webhooks for asynchronous notifications

Date: 2026-03-18

## Status

Accepted

## Context

Our API currently uses synchronous request-response patterns. As the number of
downstream services grows, response times for operations that depend on multiple
services increase linearly. Some operations (bulk imports, report generation)
can take 30+ seconds, causing HTTP timeouts.

We need a mechanism to handle long-running operations without blocking the HTTP
response. Options considered: polling, webhooks, server-sent events (SSE), and
WebSockets. Our consumers are primarily server-to-server integrations.

## Decision

We will use webhooks for asynchronous operation notifications. Consumers will
register callback URLs via the API. When a long-running operation completes,
the system will POST the result to the registered URL with an HMAC-signed payload.

## Consequences

Consumers receive near-real-time notifications without polling overhead, reducing
unnecessary API load.

We must implement webhook delivery infrastructure including retry logic with
exponential backoff, delivery logging, and a dead-letter queue for persistent
failures.

Consumers must expose a publicly reachable HTTPS endpoint, which may be a
barrier for internal tools behind firewalls. We will provide a polling fallback
for these cases.

Webhook signature verification must be documented in the API guide.
```

## Validation Checklist

When creating or reviewing an ADR, verify:

- [ ] Title is a short noun phrase with the correct number prefix
- [ ] Date is in YYYY-MM-DD format
- [ ] Status is one of: Proposed, Accepted, Deprecated, Superseded by [link]
- [ ] Context describes forces/problem without arguing for a solution
- [ ] Decision uses active voice ("We will...")
- [ ] Consequences include both positive and negative outcomes
- [ ] No extra sections added (no "Options", "Alternatives", "Risks", "References" sections)
- [ ] File is named `NNNN-title-in-lowercase-with-hyphens.md`
