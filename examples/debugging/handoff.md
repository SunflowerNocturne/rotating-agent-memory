# Handoff

## Current Status

The bug is narrowed to token validation after login, not credential verification.

## Completed Operations

- Reproduced login success followed by immediate redirect.
- Checked login handler and confirmed it returns a session token.
- Checked middleware and found it rejects the next request.

## Evidence

- Login handler logs `session created`.
- Middleware logs `token signature invalid` on the next request.
- Relevant files:
  - `src/auth/login.ts`
  - `src/auth/session.ts`
  - `src/middleware.ts`

## Current Hypothesis

Token signing and token validation may be reading different secret sources.

## Next Step

Compare the secret lookup path in `createSession` and `validateToken`, then add a focused test before changing behavior.

## Do Not Do

- Do not delete sessions.
- Do not rotate secrets until the mismatch is confirmed.
