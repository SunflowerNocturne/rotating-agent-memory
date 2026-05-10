# Context Compaction Demo

This demo shows how Rotating Agent Memory changes a long debugging session before and after context compaction.

## Scenario

A user asks an agent to fix a login bug:

```text
Users can log in, but the next page load sends them back to /login.
```

The agent investigates for an hour. Then context compaction happens, or a new chat starts.

## Without Rotating Agent Memory

The next agent has only a compressed summary or no context at all.

Typical restart:

```text
I will inspect the repository to understand the auth flow.
```

Likely failure modes:

- scans the same files again
- repeats already failed hypotheses
- treats known noise as a new bug
- changes auth code before confirming evidence
- misses user constraints such as "do not rotate production secrets"
- cannot tell which previous changes were intentional

## With Rotating Agent Memory

The previous agent maintained:

```text
goal.md
handoff.md
```

The next agent starts by reading them.

`goal.md` says:

```text
Goal: Diagnose and fix login persistence.
Success: login succeeds and the next authenticated request remains authenticated.
Constraint: do not rotate production secrets without explicit user approval.
Direction: diagnose before changing auth logic; prefer reversible fixes.
```

`handoff.md` says:

```text
Current status: narrowed to token validation after login.

Completed:
- Reproduced login success followed by redirect.
- Confirmed login handler creates a session token.
- Confirmed middleware rejects the next request.

Evidence:
- Login handler logs "session created".
- Middleware logs "token signature invalid".
- Relevant files: src/auth/login.ts, src/auth/session.ts, src/middleware.ts.

Hypothesis:
- createSession and validateToken may read different secret sources.

Next step:
- Compare secret lookup paths and add a focused test before changing behavior.

Do not do:
- Do not delete sessions.
- Do not rotate secrets until the mismatch is confirmed.
```

The next agent can continue from the actual state instead of rediscovering it.

## Why Two Files

`goal.md` should be stable. It stores why the work exists, what success means, and what must not drift.

`handoff.md` should be operational. It stores where the work is now, what was tried, what evidence exists, and what to do next.

One file can work, but two files create a clean split:

- goal: direction
- handoff: position

That split is useful when the next agent has no reliable memory.
