# Goal

Diagnose and fix the login flow where users authenticate successfully but are redirected back to the login screen on the next request.

## Success Criteria

- Login succeeds.
- The next authenticated request remains authenticated.
- The fix is supported by logs or tests.
- Any config or secret changes are backed up or reversible.

## Constraints

- Diagnose before changing auth logic.
- Do not rotate production secrets without explicit user approval.
- Prefer reversible fixes.

## Persistence Rule

Use `goal-handoff-persistence`; immediately persist task-relevant findings after
each bounded batch and discard unrelated material; goal <=6000 bytes; handoff
<=64000 bytes.
