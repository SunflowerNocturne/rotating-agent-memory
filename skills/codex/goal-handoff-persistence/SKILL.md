---
name: goal-handoff-persistence
description: Use for long-running, multi-stage, risky, or resumable work that could lose critical state across context compaction, restarts, sessions, models, or agents. Maintains a small stable goal.md and a concise successor-oriented handoff.md as mutable current-state snapshots, with bounded archival for old history.
---

# Goal + Handoff Persistence

Preserve the minimum state a completely new agent needs to continue correctly.

`handoff.md` is a mutable resume snapshot. It is not a transcript, operation log,
research notebook, status report, or history of everything that happened.

## File Roles

- `goal.md`: stable objective, acceptance criteria, core constraints, and current
  direction.
- `handoff.md`: current system/task state, active decisions, key artifacts,
  unresolved risks, and the single next action.
- `archive/`: old snapshots retained for selective historical lookup.
- `logs/`: optional detailed evidence only when auditability or exact
  reproduction is genuinely required.

Keep history out of the active resume files unless it still changes what the
successor should do.

## Mandatory Contract

1. **Goal write gate**
   Update `goal.md` only when the user explicitly changes the objective,
   deliverable, scope, core acceptance criteria, or core constraints. Routine
   progress, diagnosis, implementation, verification, and completion do not
   change `goal.md`.

2. **Bounded read gate**
   Before fully reading or writing either file, check byte sizes. `goal.md` must
   not exceed 6,000 bytes and `handoff.md` must not exceed 64,000 bytes. Use
   decimal byte counts. If a file is oversized, follow the Bounded Archive
   Protocol before any full read.

3. **Resume-critical change gate**
   After an operation, ask whether resume-critical state changed. If no current
   conclusion, state, decision, risk, artifact, rollback path, blocker, or next
   action changed, do not touch `handoff.md`.

4. **Reconciliation gate**
   When resume-critical state changes, reconcile the existing snapshot. Replace,
   merge, or delete stale information. Do not append an operation record merely
   because an operation occurred.

5. **Recovery gate**
   After context compaction, session/model/agent change, restart, or suspected
   context loss, first check file sizes, rotate oversized files if needed, then
   read the complete bounded `goal.md` and `handoff.md`. Do not rely on a compacted
   summary or repeat completed work before this recovery step.

6. **Risk gate**
   Before a risky or irreversible mutation, ensure the snapshot contains the
   relevant current state, backup or rollback path, and unresolved risk. Back up
   sensitive state before changing it.

Do not copy this full contract into every task file. A one-line note naming this
skill and the two byte limits is enough.

## Handoff Admission Test

Admit a fact to `handoff.md` only when forgetting it could cause at least one of
these outcomes:

- an incorrect or unsafe next action
- loss of a user decision or active constraint
- repetition of expensive or destructive work
- loss of a required artifact, backup, or rollback path
- concealment of an unresolved blocker, risk, or uncertainty
- inability to resume the task directly

Before writing an admitted fact, also ask:

1. Is it still current?
2. Does it belong to this task's goal?
3. Does it replace or resolve an existing entry?
4. Can raw detail be referenced by path instead of copied?
5. Can it be stated in one concise bullet?

If the fact fails these checks, omit it or place it in an optional log when a
durable audit trail is actually required.

## Do Not Record By Default

Do not add these to `handoff.md` unless they changed resume-critical state:

- the user merely asked for progress or status
- reading this skill, checking file sizes, or updating the handoff itself
- creating routine task-memory directories
- ordinary file reads, searches, tool calls, or commands
- read-only checks that confirmed an already-established conclusion
- failed/no-result probes that did not change diagnosis or next action
- repeated validations of the same conclusion
- transient narration, implementation play-by-play, or chat summaries
- full command output, long rule lists, raw logs, or copied source material
- completed next steps, resolved risks, and superseded hypotheses

Never create `Completed Operations`, dated update streams, or similar
append-only sections by default.

## Required Handoff Shape

Use this structure and omit empty sections:

```markdown
# Handoff

## Current Snapshot
- Only current facts needed to understand the live state.

## Decisions And Constraints
- Active user decisions and constraints that must not be violated.

## Artifacts And Rollback
- Key files, outputs, backups, evidence locations, and rollback paths.

## Open Risks And Uncertainty
- Only unresolved items. Mark uncertain claims explicitly.

## Next Action
1. The single most direct next action.
```

Use the fewest bullets that preserve safe resumption. Prefer one fact per bullet,
one or two sentences, and no nested chronology. Reference `goal.md` instead of
duplicating its objective and constraints.

## Reconcile Instead Of Append

Apply these lifecycle rules whenever the snapshot changes:

- New evidence supersedes a hypothesis: replace the hypothesis with the current
  conclusion.
- A risk or blocker is resolved: remove it.
- The next action is completed: replace it with the new single next action.
- Multiple checks support one conclusion: retain only the strongest current
  evidence or one evidence path.
- A path, version, process ID, or system state changes: update the existing fact;
  do not preserve the obsolete value in the active snapshot.
- A rejected hypothesis matters only as a future safety warning: retain one short
  decision line explaining what not to retry. Otherwise delete it.

Deletion of obsolete information is required maintenance, not information loss.
Historical snapshots remain searchable in `archive/` when preservation matters.

## Update Timing

Reconcile `handoff.md` at meaningful state transitions, including:

- a diagnosis or decision changes
- a mutation changes external or on-disk state
- a new artifact, backup, or rollback point becomes authoritative
- a blocker, risk, or uncertainty appears or is resolved
- the direct next action changes
- a milestone or task phase completes
- before compaction, handoff, pause, or exit when current state is not yet captured

For a long-running operation, record intent before launch only when interruption
would leave ambiguous or risky state. Replace that intent with the outcome when
the operation finishes. Do not retain both as permanent history.

## Milestone Rebase

At phase changes such as diagnosis to implementation, implementation to
verification, or verification to user confirmation, rebuild `handoff.md` as a
fresh current snapshot:

1. Preserve the old snapshot in `archive/` only if its history may matter.
2. Re-evaluate every active fact with the admission test.
3. Drop completed operations, stale evidence, resolved branches, and old next
   steps.
4. Keep only current state, active decisions, authoritative artifacts,
   unresolved risks, and the new next action.
5. Verify the new snapshot is internally consistent and within 64,000 bytes.

Do not wait for the byte limit before removing stale information.

## Scope Split

Do not turn one handoff into a product, machine, or project encyclopedia. When a
new request no longer advances the current `goal.md`, create a separate durable
task directory. Add a short cross-reference only when the tasks genuinely depend
on each other.

## Optional Logs

Create detailed logs only when required for:

- high-risk repair or exact rollback
- user-requested audit history
- reproducible research or evidence chains
- long builds, migrations, or tests whose raw output may be needed later

Store raw commands and outputs in `logs/` and reference the relevant path from
the handoff. Do not move routine verbosity into logs by default.

## Bounded Archive Protocol

Use byte size because it is deterministic and cheap to check.

If `goal.md` exceeds 6,000 bytes or `handoff.md` exceeds 64,000 bytes:

1. Create `archive/` beside the active files.
2. Move the oversized file to a timestamped path such as
   `archive/handoff-20260801-210000.md`.
3. Do not read the oversized archive in full. Inspect bounded head/tail slices,
   headings, and targeted search hits for current state, next action, decisions,
   risks, backups, verification, and blockers.
4. Recreate the active file at its original path.
5. For `goal.md`, retain only the current objective, acceptance criteria, core
   constraints, and direction.
6. For `handoff.md`, use the required five-section shape and the admission test.
7. State any uncertainty caused by bounded reconstruction instead of inventing
   missing facts.
8. Record the archive path only when a successor may need selective history.

Before a write that would cross a limit, rebase or archive first. Never leave an
active resume file above its limit.

## Initialization

For a qualifying task:

1. Create a durable task directory outside temporary or easily cleaned storage.
2. Create concise `goal.md` and `handoff.md` files using the roles and shape above.
3. Add one short protocol note, for example:
   `Persistence: use goal-handoff-persistence; goal <=6000 bytes; handoff <=64000 bytes.`
4. Do not create `logs/`, `archive/`, or other folders until they are needed.

## Final Verification

Before pausing, handing off, or declaring completion:

- check both byte limits
- remove stale or duplicated facts
- confirm exactly one current next action, or state that no action remains
- classify unresolved items as confirmed issues, acceptable noise, awaiting user
  confirmation, or areas requiring explicit approval
- verify artifact and rollback paths still exist when they are important

Completion should usually make the handoff shorter. Preserve the final result,
remaining risks, and rollback information; remove the implementation diary.
