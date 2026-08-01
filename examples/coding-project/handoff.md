# Handoff

Persistence: use `goal-handoff-persistence`; goal <=6000 bytes; handoff <=64000 bytes.

## Current Snapshot

- The scaffold uses Vite, React, plain CSS, and npm; the starter screen is still active.
- There is no backend or database layer.

## Decisions And Constraints

- Keep persistence in local storage. Do not add a backend or rewrite the build setup.

## Artifacts And Rollback

- Entry points: `src/main.jsx`, `src/App.jsx`, and `src/App.css`.
- Dependency evidence: `package.json`.

## Next Action

1. Replace the starter screen with the local-storage task tracker, then verify the workflow in the dev server.
