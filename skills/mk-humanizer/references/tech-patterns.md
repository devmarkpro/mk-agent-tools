# Technical Writing AI Patterns

Patterns specific to AI-generated technical documentation, engineering specs, and developer-facing content. Apply these alongside the general patterns catalog when content type is `technical` or `mixed`.

## T1. Fake Precision

**Problem:** Unsourced specific numbers that sound credible but have no basis.

**Before:**
> This approach reduces latency by approximately 40% while improving throughput by 2.3x.

**After:**
> This approach reduces latency (benchmark results in `/docs/perf-comparison.md`).

Or if you have real numbers, keep them and cite the source.

## T2. Buzzword Stacking

**Problem:** Chaining meaningless modifiers that sound technical but say nothing.

**Watch for:** leveraging, cloud-native, microservices architecture, AI-powered, next-generation, cutting-edge, state-of-the-art, enterprise-grade, industry-leading

**Before:**
> The platform leverages a cloud-native microservices architecture with AI-powered observability and enterprise-grade security.

**After:**
> The platform runs on Kubernetes, with each service deployed independently. Monitoring uses Datadog. Auth goes through OAuth 2.0 with RBAC.

## T3. Vague Architecture Descriptions

**Problem:** Sounds technical, says nothing concrete.

**Watch for:** robust and scalable, highly available, fault-tolerant, well-architected, modern stack, best-in-class

**Before:**
> The system uses a robust and scalable architecture designed for high availability and fault tolerance.

**After:**
> The system runs across three AWS regions with automatic failover. Each region handles traffic independently.

## T4. Over-Abstraction

**Problem:** Generic framework language that could describe any system.

**Watch for:** provides a comprehensive framework, enables seamless integration, facilitates streamlined workflows, empowers teams to

**Before:**
> The module provides a comprehensive framework for managing configuration across distributed systems, enabling seamless integration with existing infrastructure.

**After:**
> The module reads config from etcd and writes it to each node's local `/etc/app/config.yml` on change.

## T5. Tutorial Mode

**Problem:** Over-explaining basics while under-explaining the hard parts. AI defaults to introductory explanations regardless of audience.

**Before:**
> A database is a structured collection of data. In this system, we use PostgreSQL, which is a relational database management system. Tables store data in rows and columns. Our users table has the following columns...

**After:**
> The users table schema: [table definition]. The `role` column uses an enum because roles are validated at the application layer, not the database.

The interesting part is *why*, not *what a database is*.

## T6. Contextually Empty Accuracy

**Problem:** Describes what code does accurately but never explains why. AI can read code; it can't explain the decision behind it.

**Before:**
> The `retry` function takes a callback and a max retry count. It executes the callback and retries on failure up to the specified number of times with exponential backoff.

**After:**
> Retries use exponential backoff because the upstream payment API rate-limits at 100 req/s and returns 429s in bursts. Three retries with backoff keeps us under the limit without blocking the checkout flow.

## T7. Passive Voice Hiding Agency

**Problem:** Obscures who decided, who owns, who is responsible.

**Watch for:** it was decided that, it has been determined, the approach was chosen, the service was deprecated

**Before:**
> It was decided that the legacy API would be deprecated in Q3 to align with the modernization initiative.

**After:**
> The platform team is deprecating the legacy API in Q3. The new REST API covers all existing use cases except batch exports (tracked in JIRA-4521).

## T8. Fake Trade-Off Analysis

**Problem:** Lists pros and cons without taking a position. AI is trained to be balanced, which produces empty analysis.

**Before:**
> While Redis offers excellent read performance, PostgreSQL provides stronger consistency guarantees. Both approaches have their merits and can be effective depending on the specific requirements.

**After:**
> We chose Redis for the session store because reads are 10x more frequent than writes and we can tolerate stale data for up to 30 seconds. If we later need strict consistency, we'll move sessions to PostgreSQL, but that's not worth the latency cost today.

## T9. Formulaic Risk/Challenges Sections

**Problem:** Boilerplate risk sections that acknowledge challenges without specifics.

**Before:**
> While this approach offers significant benefits, it also introduces challenges related to scalability, maintainability, and operational complexity. Despite these challenges, the benefits outweigh the risks.

**After:**
> The main risk is connection pool exhaustion under sustained load (>5k concurrent users). Mitigation: circuit breaker on the DB connection with fallback to cached responses. We tested this under 8k concurrent users in staging — response times degrade but the service stays up.

## T10. Excessive Inline Code Formatting

**Problem:** Marking everything as `code` when prose works fine.

**Before:**
> The `users` can `configure` the `settings` by modifying the `configuration file` in the `home directory`.

**After:**
> Users can configure settings by editing the config file in their home directory.

Reserve backticks for actual code: function names, file paths, commands, variable names, config keys.

## Reference

Patterns compiled from: mywritingtwin.com (AI technical doc profile), shellnetsecurity.com (AI documentation problems), engineeringcopywriter.com (AI detection in technical content), and direct observation of AI-generated engineering artifacts.
