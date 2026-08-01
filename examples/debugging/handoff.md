# Handoff

Persistence: use `goal-handoff-persistence`; goal <=6000 bytes; handoff <=64000 bytes.

## Current Snapshot

- Login creates a session token, but middleware rejects the next request with `token signature invalid`; credential verification is not the failing stage.

## Decisions And Constraints

- Diagnose before changing auth behavior. Do not delete sessions or rotate production secrets without explicit approval.

## Artifacts And Rollback

- Relevant files: `src/auth/login.ts`, `src/auth/session.ts`, and `src/middleware.ts`.

## Open Risks And Uncertainty

- Unconfirmed: token signing and validation may read different secret sources.

## Next Action

1. Compare secret lookup in `createSession` and `validateToken`, then add a focused test before changing behavior.
