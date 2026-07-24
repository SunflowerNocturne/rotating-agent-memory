# Changelog

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
