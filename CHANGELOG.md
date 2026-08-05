# Changelog

## v0.3.2 - Transactional Research Checkpoints

This release closes the remaining pre-compaction loss window in v0.3.1. Agents
could still read several large or parallel sources and compact before reaching
the delayed checkpoint, losing the entire investigation and restarting it.

Compared with v0.3.1:

- Adds a strict relevance gate: persist only findings that directly affect the
  current task; discard tangents, raw material, and merely interesting facts.
- Classifies each source result as relevant-new, relevant-duplicate/superseding,
  or unrelated/non-actionable.
- Makes persistence of a relevant new finding the next operation after its
  bounded read/search batch, before any further tool call, edit, build, test, or
  agent task.
- Allows at most one uncheckpointed batch: one large source/chunk or at most two
  sources already known to be small.
- Requires a reconciled `notes/active-research.md` before a second research batch
  while keeping `handoff.md` sufficient for direct resumption.
- Retains synthesized conclusions instead of read chronology and keeps the
  No-Reread Test as the acceptance criterion.
- Keeps the exact decimal limits of 6,000 bytes for `goal.md` and 64,000 bytes for
  `handoff.md`.

The v0.3.1 and all earlier tags remain available unchanged as rollback points.

## v0.3.1 - Knowledge Checkpoints

This release corrects an over-compression failure in v0.3.0: agents could omit
valuable conclusions from file reading and web research merely because no file
or external state had changed, forcing the same discovery work after every
context compaction.

Compared with v0.3.0:

- Expands persistence from resume-critical state changes to resume-critical
  state **or working-understanding** changes.
- Requires a synthesized knowledge checkpoint after roughly 3-5 substantive
  sources, when a research subproblem reaches a conclusion, and before the
  research-to-implementation transition.
- Clarifies that agents should omit the chronology of reads and searches while
  retaining the diagnosis, source map, intended change, rationale, invariants,
  and unresolved questions those sources establish.
- Adds a Working Understanding / Implementation Brief under the existing current
  snapshot when discovery has occurred.
- Makes the No-Reread Test the primary handoff acceptance criterion: a fresh
  agent must be able to perform the next action without repeating the completed
  broad investigation.
- Adds optional `notes/active-research.md` for source-level detail while requiring
  the handoff itself to remain sufficient.
- Keeps the exact decimal limits of 6,000 bytes for `goal.md` and 64,000 bytes for
  `handoff.md`.

The v0.3.0 and all earlier tags remain available unchanged as rollback points.

## v0.3.0 - Concise State Snapshots

This release changes `handoff.md` from an operation-by-operation record into a
mutable, successor-oriented snapshot of current state.

Compared with v0.2.1:

- Replaces the unconditional post-operation write rule with a resume-critical
  state-change gate.
- Requires agents to reconcile existing state by replacing, merging, and
  deleting stale facts instead of appending chronology.
- Defines a fixed compact handoff shape: current snapshot, decisions and
  constraints, artifacts and rollback, open risks and uncertainty, and exactly
  one next action.
- Adds an explicit admission test and a do-not-record list for status requests,
  routine reads, no-op probes, repeated validation, raw output, completed steps,
  and superseded hypotheses.
- Adds milestone rebasing, unrelated-scope splitting, and optional logs for work
  that genuinely needs an audit trail.
- Uses exact decimal hard limits of 6,000 bytes for `goal.md` and 64,000 bytes for
  `handoff.md`.
- Reconstructs oversized active files using bounded slices and targeted searches
  so archive rotation does not recreate a context-exhaustion loop.

The v0.2.1, v0.2.0, and v0.1.0 tags remain available as rollback points.

## v0.2.1 - Relax Archive Thresholds

This release keeps the bounded archive rotation behavior from v0.2.0, but raises the default limits so normal long-running work has more room before rotation:

- Archives `handoff.md` when it grows beyond 128,000 bytes.
- Archives `goal.md` when it grows beyond 32,000 bytes.

Compared with v0.2.0, this reduces unnecessary rotation while still preventing very large active resume files from causing recursive context exhaustion.

## v0.2.0 - Bounded Archive Rotation

This release changes the protocol from unlimited append-only `goal.md` and `handoff.md` files to bounded active resume files with archive rotation.

Compared with v0.1.0:

- Adds a bounded file guard before full reads, updates, pauses, resumes, and handoffs.
- Archives `handoff.md` when it grows beyond 32,000 bytes.
- Archives `goal.md` when it grows beyond 16,000 bytes.
- Moves oversized files into timestamped `archive/` entries instead of reading them fully into context.
- Recreates fresh active files that keep only the current goal, current state, relevant evidence, risks, backup paths, and next action.
- Treats archived files as searchable evidence stores, not default resume files.
- Updates the post-compaction recovery rule so agents check sizes and rotate oversized files before reading current bounded files.

This avoids a failure mode where a huge handoff fills the context window, triggers compaction, then forces the next agent to reread the same huge handoff and repeat the loop.

## v0.1.0 - Initial Release

Initial two-file Goal + Handoff protocol for rotating AI agents:

- `goal.md` for stable objective, constraints, direction, and acceptance criteria.
- `handoff.md` for current state, evidence, completed work, risks, backups, failures, and next steps.
- Install scripts and examples for Codex and Claude Code.
