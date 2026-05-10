---
name: goal-handoff-persistence
description: Use when a task is long-running, multi-stage, likely to hit context compacting, needs resume or handoff across sessions, or would suffer from lost context. Applies to large coding projects, debugging, system repair, research, long learning tasks, writing projects, architecture work, and other durable goals. Maintains goal.md and handoff.md as external task memory.
---

# Goal + Handoff Persistence

External memory for rotating agents.

Use this skill when the task may outgrow the current context window, span multiple phases, require restart or resume, or involve enough state that losing context would cause repeated work, direction drift, unsafe actions, or forgotten decisions.

This is a lightweight persistence protocol. Do not create a large project structure by default. Start with a durable task working directory and two files:

- `goal.md`: why the task exists, what success means, constraints, current direction, and acceptance criteria.
- `handoff.md`: current state, completed actions, evidence, risks, backups, failures, next steps, and resume instructions.

These files are the external memory for context compacting, restarts, session changes, model changes, and handoffs.

Assume another agent with no reliable memory may take over at any time. Write `goal.md` and `handoff.md` so that agent can continue without relying on chat history, compressed summaries, or guesswork.

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
   Before starting or resuming work, read both `goal.md` and `handoff.md`.
   Any important diagnosis, action, risk, result, backup, verification, or next-step change must be reflected in `goal.md` or `handoff.md`.

4. Keep the files current during the task.
   Update `goal.md` when the goal, constraints, success criteria, current direction, or "do not do" guidance meaningfully changes. Do not churn it for routine progress.
   Update `handoff.md` after each completed operation, including diagnostics, edits, commands, backups, failures, verification steps, and user-confirmed decisions.

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
   For downloads, installs, scans, builds, migrations, validation, or other long-running work, update `handoff.md` at key stages instead of waiting until the end.

11. Before compacting, pausing, restarting, switching sessions, or leaving, synchronize both files.
    Include the current state, completed work, unfinished work, things not to do, and the first step after resuming.

12. Before starting or resuming work, read `goal.md` and `handoff.md` before continuing.
    Do not rely on memory. Do not repeat completed work. Do not undo existing fixes unless explicitly required.

13. Final verification must be recorded.
    Write the validation result, remaining risks, completion status, and any unresolved issues into the files.

## Optional Artifacts

Do not create a large folder structure by default. Start with only the durable task directory plus `goal.md` and `handoff.md`.

When the task actually needs them, create additional files or folders such as:

- `backups/` for backups and rollback points
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

Do not turn `handoff.md` into a raw chat transcript. It should be a usable handoff document.

## Final State Classification

At final verification, classify remaining items as:

- confirmed real issues
- acceptable noise
- awaiting user confirmation
- areas that should not be changed further without explicit approval

If the task is complete, say so in both files. If it is not complete, record the exact remaining blocker and the safest next action.

## Writing Style

Avoid vague entries. Prefer:

- evidence-backed conclusions
- clear current status
- exact paths and commands
- timestamps when useful
- explicit next steps
- explicit warnings about what not to touch

Write for the next agent or future session, not for the current chat.
