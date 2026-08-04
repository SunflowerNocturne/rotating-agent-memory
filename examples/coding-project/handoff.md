# Handoff

Persistence: use `goal-handoff-persistence`; goal <=6000 bytes; handoff <=64000 bytes.

## Current Snapshot

- The scaffold uses Vite, React, plain CSS, and npm; the starter screen is still active.
- There is no backend or database layer.

### Working Understanding / Implementation Brief

- Replace the starter UI in `src/App.jsx`; keep `src/main.jsx` and the Vite setup intact.
- Own project/task state in the app, initialize it from local storage, and persist changes after CRUD or status updates.
- Extend `src/App.css` for the responsive working interface rather than introducing another styling system.

## Decisions And Constraints

- Keep persistence in local storage. Do not add a backend or rewrite the build setup.

## Artifacts And Rollback

- Entry points: `src/main.jsx`, `src/App.jsx`, and `src/App.css`.
- Dependency evidence: `package.json`.

## Next Action

1. Implement the state model and local-storage lifecycle in `src/App.jsx`, then build the task UI around it.
