# Handoff

Persistence: use `goal-handoff-persistence`; goal <=6000 bytes; handoff <=64000 bytes.

## Current Snapshot

- Login creates a session token, but middleware rejects the next request with `token signature invalid`; credential verification is not the failing stage.

### Working Understanding / Implementation Brief

- `src/auth/login.ts` establishes that credentials succeed and a session is created.
- `src/auth/session.ts:createSession` signs the token; `src/middleware.ts:validateToken` rejects it on the next request.
- Compare only the signing/validation secret lookup paths first; do not change behavior until a focused test reproduces the mismatch.

## Decisions And Constraints

- Diagnose before changing auth behavior. Do not delete sessions or rotate production secrets without explicit approval.

## Artifacts And Rollback

- Relevant edit/evidence paths are recorded in the implementation brief above.

## Open Risks And Uncertainty

- Unconfirmed: token signing and validation may read different secret sources.

## Next Action

1. Compare secret lookup in `createSession` and `validateToken`, then add a focused test before changing behavior.
