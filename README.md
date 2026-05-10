# Rotating Agent Memory

A tiny Goal + Handoff protocol for AI coding agents that forget.

Your agent is not one continuous engineer. In long projects, it behaves more like a rotating crew of short-lived agents: one works for a while, context compacts, another takes over, and the project survives only if the handoff is good.

Rotating Agent Memory gives Claude Code, Codex, and similar agents a lightweight external memory layer:

- `goal.md` keeps the stable goal, constraints, direction, and success criteria.
- `handoff.md` keeps the current state, evidence, completed work, risks, backups, failures, and next steps.

No database. No framework. No giant memory system. Just two Markdown files that make long-running agent work resumable.

## Why This Exists

Context compaction is not real memory. It is lossy oral tradition.

Without durable task memory, a fresh agent often has to rediscover:

- what the project is trying to do
- what success means
- which files and decisions matter
- which paths were already tried
- which failures are real bugs versus noise
- what was changed, backed up, verified, or ruled out
- what the next safe step is

This protocol assumes another agent with no reliable memory may take over at any time.

## When To Use It

Use it for long or stateful work:

- large coding projects or new app builds
- debugging and bug-fix investigations
- system repair or environment diagnosis
- multi-step refactors or migrations
- long learning sessions
- research projects
- writing, worldbuilding, or planning projects
- architecture and design work
- downloads, installs, scans, builds, migrations, or long verification
- any task where context loss would be expensive or risky

Skip it for quick one-shot answers, tiny edits, or simple commands.

## Core Rule

Start each durable task with a task-specific working directory containing:

```text
goal.md
handoff.md
```

Update `goal.md` only when the goal, constraints, success criteria, direction, or "do not do" guidance meaningfully changes.

Update `handoff.md` after each completed operation: diagnostics, edits, commands, backups, failures, verification, and user-confirmed decisions.

## Install

Clone this repo, then run:

```bash
./install.sh --all
```

Install only for Codex:

```bash
./install.sh --codex
```

Install only for Claude Code:

```bash
./install.sh --claude
```

The installer copies the skill to:

```text
~/.codex/skills/goal-handoff-persistence/SKILL.md
~/.claude/skills/goal-handoff-persistence.md
~/.claude/skills/goal-handoff-persistence/SKILL.md
```

Restart or reload your agent app after installing.

## Manual Install

For Codex:

```bash
mkdir -p ~/.codex/skills/goal-handoff-persistence
cp skills/codex/goal-handoff-persistence/SKILL.md ~/.codex/skills/goal-handoff-persistence/SKILL.md
```

For Claude Code:

```bash
mkdir -p ~/.claude/skills/goal-handoff-persistence
cp skills/claude-code/goal-handoff-persistence.md ~/.claude/skills/goal-handoff-persistence.md
cp skills/claude-code/goal-handoff-persistence/SKILL.md ~/.claude/skills/goal-handoff-persistence/SKILL.md
```

## Examples

See:

- `examples/coding-project/`
- `examples/debugging/`
- `examples/learning/`

Each example shows the two-file pattern without turning the task into a documentation ritual.

## Design Philosophy

This is not a general memory bank, personal knowledge base, or replacement for project docs.

It is a handoff protocol for rotating agents:

- keep the goal stable
- keep the current state resumable
- record evidence
- back up before risky changes
- prefer reversible fixes
- distinguish real issues from noise
- make the next step obvious

Write for the next agent, not for the current chat.

## License

MIT
