---
name: goal-handoff-persistence
description: Use when a task is long-running, multi-stage, likely to hit context compacting, needs resume or handoff across sessions, or would suffer from lost context. Applies to large coding projects, debugging, system repair, research, long learning tasks, writing projects, architecture work, and other durable goals. Maintains bounded goal.md and handoff.md external memory with archive rotation for oversized history.
---

# Goal + Handoff Persistence

External memory for rotating agents.

Use this skill when the task may outgrow the current context window, span multiple phases, require restart or resume, or involve enough state that losing context would cause repeated work, direction drift, unsafe actions, or forgotten decisions.

This is a lightweight persistence protocol. Do not create a large project structure by default. Start with a durable task working directory and two files:

- `goal.md`: why the task exists, what success means, constraints, current direction, and acceptance criteria.
- `handoff.md`: current state, completed actions, evidence, risks, backups, failures, next steps, and resume instructions.

These files are the external memory for context compacting, restarts, session changes, model changes, and handoffs.

Assume another agent with no reliable memory may take over at any time. Write `goal.md` and `handoff.md` so that agent can continue without relying on chat history, compressed summaries, or guesswork.

## Mandatory State-Update Contract

These rules override any looser wording elsewhere in this skill:

1. **Goal write gate**: Update `goal.md` if and only if the user explicitly changes the task objective, deliverable, scope, core acceptance criteria, or core constraints, or explicitly asks to update `goal.md`. Never change it for routine progress, research, diagnostics, implementation, failures, fixes, validation, or completion status.
2. **Bounded file guard**: Before fully reading, updating, compacting, pausing, resuming, or handing off, check the sizes of `goal.md` and `handoff.md`. If `handoff.md` is larger than 128,000 bytes or `goal.md` is larger than 32,000 bytes, run the Bounded Archive Protocol below before any full read. Never read an oversized `goal.md` or `handoff.md` completely into context.
3. **Handoff write barrier**: Immediately after every completed operation, update `handoff.md` before starting the next operation. Record what was attempted, inputs or commands, success or failure, evidence and artifact paths, state impact, and the next action. For a long-running operation, record the intended operation before launching it, then record its result immediately when it finishes or fails. Keep the updated `handoff.md` under the size threshold; if the update would exceed it, archive first.
4. **Post-compaction recovery gate**: After any context compaction, summary takeover, session/model/agent switch, or suspected context loss, stop. The first action must be to check the sizes of `goal.md` and `handoff.md`, run archive rotation if needed, and then read the current bounded `goal.md` and `handoff.md` completely from beginning to end. Do not run another command, continue prior work, or rely on the compacted summary until the current bounded files have been fully read.

When initializing a task, write this contract into both `goal.md` and `handoff.md` themselves.

## Bounded Archive Protocol

The active `goal.md` and `handoff.md` are resume files, not permanent raw history. Keep them short enough that a future agent can safely read them without triggering another context compaction.

Default hard limits:

- Archive `handoff.md` when it is larger than 128,000 bytes.
- Archive `goal.md` when it is larger than 32,000 bytes.

Use byte size rather than token count because it is fast, deterministic, and available in every shell (`wc -c goal.md handoff.md`). Smaller limits are allowed when the task is especially sensitive to context budget.

When a file exceeds its limit:

1. Create `archive/` next to `goal.md` and `handoff.md`.
2. Move the oversized file into `archive/` with a timestamped name such as `archive/handoff-20260724-164500.md` or `archive/goal-20260724-164500.md`.
3. Do not paste or read the entire archived file into context. Read bounded slices such as the first 120 lines, last 220 lines, and targeted search hits for terms like `Current State`, `Next Step`, `Risk`, `Backup`, `Verification`, `Blocked`, `Do not`, and user-stated goals.
4. Create a fresh file at the original path.
   - New `handoff.md`: summarize the current state, still-relevant completed work, latest evidence, active risks, backup paths, next action, and the archive path. Add a note that old history is searchable in `archive/` and should be read selectively.
   - New `goal.md`: preserve only the current objective, success criteria, active constraints, current direction, and things not to do. Remove completed goals, stale branches, old progress, and historical commentary.
5. Record the archive path and the reason for rotation in the new file.
6. If the useful current state cannot be reconstructed from bounded slices and targeted searches, write the uncertainty clearly and ask the user before taking risky action.

Archived files are evidence stores. They are not part of the default resume read. Read them only when the current bounded files point to a specific archive section, when investigating a regression, or when the user asks for historical detail.

## When To Use

Use for long or stateful tasks, including:

- large coding projects or new app builds
- debugging and bug-fix investigations
- system repair or environment diagnosis
- multi-step refactors or migrations
- long learning sessions that may require many rounds or very high token usage
- research projects
- writing, worldbuilding, or planning projects
- architecture or design work
- tasks involving downloads, installs, scans, builds, migrations, long verification, or waiting for user confirmation
- any task where context loss would be expensive, risky, or likely to cause repeated work

Do not use for simple one-shot answers, tiny edits, or short commands unless the user asks for persistent tracking.

## Core Workflow

1. Create a durable task working directory.
   Avoid temporary folders, sync folders, or locations likely to be cleaned automatically.

2. Create `goal.md` and `handoff.md`.

3. Write the persistence rule into both files themselves:
   Include the Mandatory State-Update Contract above.
   Include the Bounded Archive Protocol above or a concise equivalent.
   Before starting or resuming work, check file sizes, rotate oversized files if needed, then read the current bounded `goal.md` and `handoff.md` completely.

4. Keep the files current during the task.
   Update `goal.md` if and only if the user explicitly changes the objective, deliverable, scope, core acceptance criteria, or core constraints.
   Immediately after each completed operation, update `handoff.md` before the next operation, including diagnostics, reads, searches, edits, commands, downloads, backups, failures, builds, renders, verification steps, and user-confirmed decisions.
   Keep both files below their size limits by archiving stale history instead of appending forever.

5. Diagnose before fixing.
   Only fix problems supported by evidence. Distinguish real issues from ordinary noise, transient startup load, stale state, or false positives.

6. Record evidence.
   Link each important conclusion to logs, command output, file paths, timestamps, screenshots, tests, or other concrete sources.

7. Back up before risky changes.
   Before changing services, configs, startup items, databases, drivers, registries, or other sensitive state, create a backup or rollback point and record its path in `handoff.md`.

8. Prefer reversible fixes when possible.
   Disable, set manual startup, narrow scope, exclude, isolate, or make a reversible config change before deleting or permanently changing state.

9. Keep every operation traceable.
   Record what was done, why it was done, whether it succeeded, where it failed, and what should happen next.

10. Update during long tasks.
    Before starting a download, install, scan, build, migration, validation, or other long-running operation, record what is about to run. When it completes or fails, immediately update `handoff.md` before doing anything else.

11. Before compacting, pausing, restarting, switching sessions, or leaving, synchronize both files.
    Check file sizes first. If either file is oversized, run archive rotation before leaving.
    Include the current state, completed work that still matters, unfinished work, things not to do, archive paths, and the first step after resuming.

12. Before starting or resuming work, read `goal.md` and `handoff.md` before continuing.
    After compaction or context loss, the first action is the bounded file guard: check file sizes, rotate oversized files if needed, then read the current bounded files completely. Do not rely on memory or a compacted summary. Do not repeat completed work. Do not undo existing fixes unless explicitly required.

13. Final verification must be recorded.
    Write the validation result, remaining risks, completion status, and any unresolved issues into `handoff.md`. Do not edit `goal.md` merely because the task reached a new progress or completion state.

## Optional Artifacts

Do not create a large folder structure by default. Start with only the durable task directory plus `goal.md` and `handoff.md`.

When the task actually needs them, create additional files or folders such as:

- `backups/` for backups and rollback points
- `archive/` for oversized older `goal.md` or `handoff.md` files that should remain searchable but not be read by default
- `logs/` for command output, runtime logs, scans, or build logs
- `scripts/` for helper scripts used during the task
- `reports/` for diagnostics, summaries, screenshots, traces, or verification reports
- `downloads/` for downloaded installers, archives, datasets, or references

Record important artifact paths in `handoff.md` so a future session can find and trust them.

## File Guidance

Keep `goal.md` stable and strategic. It should answer:

- Why are we doing this?
- What counts as success?
- What constraints or user preferences matter?
- What is the current direction?
- What should not be done?
- How will the task be accepted or verified?

Do not update `goal.md` unless the user explicitly changes one of those goal-level items or explicitly requests a goal-file edit.

If `goal.md` grows beyond 32,000 bytes, archive it and recreate a short current-goal file. Long completed goals and old branches belong in `archive/`, not in the active resume file.

Keep `handoff.md` operational and easy to resume from. It should answer:

- Where are we now?
- What has already been done?
- What evidence supports the current conclusions?
- What changed?
- Where are backups or rollback points?
- What failed, and where?
- What risks remain?
- What is the next step?
- What is the first step after resuming?

It must always reflect the most recently completed operation before another operation begins.

If `handoff.md` grows beyond 128,000 bytes, archive it and recreate a short current-handoff file. The active handoff should contain enough current state to resume, plus archive paths for selective historical lookup. Do not keep appending old history until the file becomes unsafe to reread.

Do not turn `handoff.md` into a raw chat transcript. It should be a usable handoff document.

## Final State Classification

At final verification, classify remaining items as:

- confirmed real issues
- acceptable noise
- awaiting user confirmation
- areas that should not be changed further without explicit approval

Record completion or the exact remaining blocker and safest next action in `handoff.md`. Update `goal.md` only when the user explicitly changes the goal-level contract.

## Writing Style

Avoid vague entries. Prefer:

- evidence-backed conclusions
- clear current status
- exact paths and commands
- timestamps when useful
- explicit next steps
- explicit warnings about what not to touch

Write for the next agent or future session, not for the current chat.
