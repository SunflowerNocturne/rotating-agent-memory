# Goal

Build a usable task tracker web app with project lists, task CRUD, status filters, and persistent local storage.

## Success Criteria

- Users can create, edit, complete, and delete tasks.
- Tasks persist after browser refresh.
- The first screen is the working app, not a landing page.
- The UI is responsive on desktop and mobile.
- Existing project conventions should be followed once discovered.

## Constraints

- Keep implementation small and shippable.
- Avoid unrelated refactors.
- Do not introduce a backend unless the user explicitly asks.

## Persistence Rule

Use `goal-handoff-persistence`; immediately persist task-relevant findings after
each bounded batch and discard unrelated material; goal <=6000 bytes; handoff
<=64000 bytes.
