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

The previous agent did not wait until the end of the investigation to write. It
worked in bounded transactions:

1. A small login-path batch established that credentials succeed and a session
   is created. That task-relevant conclusion was written immediately before any
   further inspection.
2. Because research needed another batch, the agent created
   `notes/active-research.md`, then compared the signing and validation paths.
   Their shared conclusion and source map were reconciled into the handoff before
   another command or edit.
3. An unrelated UI stylesheet detail was discarded. It never entered task
   memory merely because the agent happened to see it.

At no point was more than one bounded research batch waiting in volatile
context. The previous agent maintained:

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
Current Snapshot:
- Login creates a session token, but middleware rejects the next request with
  "token signature invalid".
- Working understanding: createSession in src/auth/session.ts signs the token;
  validateToken in src/middleware.ts performs the failing verification. The
  remaining comparison is their secret lookup path, not the credential flow.

Decisions And Constraints:
- Do not delete sessions or rotate secrets before the mismatch is confirmed.

Artifacts And Rollback:
- src/auth/login.ts establishes that credential verification succeeds.
- src/auth/session.ts:createSession is the signing path.
- src/middleware.ts:validateToken is the failing validation path.

Open Risks And Uncertainty:
- Unconfirmed: createSession and validateToken may read different secret sources.

Next Action:
1. Compare secret lookup in createSession and validateToken, then add a focused
   test that reproduces the mismatch before changing behavior.
```

The next agent can continue from the actual state instead of rediscovering it.

## Why Two Files

`goal.md` should be stable. It stores why the work exists, what success means, and what must not drift.

`handoff.md` should be operational and mutable. It stores the current state,
synthesized working understanding, active decisions, key artifacts, unresolved
risks, implementation brief, and one next action. Completed operations and
superseded hypotheses are removed rather than accumulated. A fresh agent must
not need to repeat the source-reading phase to understand why the next action is
correct.

One file can work, but two files create a clean split:

- goal: direction
- handoff: position

That split is useful when the next agent has no reliable memory.
