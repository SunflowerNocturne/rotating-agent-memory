#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

install_codex() {
  target="$HOME/.codex/skills/goal-handoff-persistence"
  mkdir -p "$target"
  cp "$ROOT_DIR/skills/codex/goal-handoff-persistence/SKILL.md" "$target/SKILL.md"
  printf 'Installed Codex skill to %s\n' "$target/SKILL.md"
}

install_claude() {
  base="$HOME/.claude/skills"
  target="$base/goal-handoff-persistence"
  mkdir -p "$target"
  cp "$ROOT_DIR/skills/claude-code/goal-handoff-persistence.md" "$base/goal-handoff-persistence.md"
  cp "$ROOT_DIR/skills/claude-code/goal-handoff-persistence/SKILL.md" "$target/SKILL.md"
  printf 'Installed Claude Code skill to %s\n' "$base/goal-handoff-persistence.md"
  printf 'Installed Claude Code skill to %s\n' "$target/SKILL.md"
}

usage() {
  cat <<'USAGE'
Usage: ./install.sh [--all|--codex|--claude]

Options:
  --all      Install for Codex and Claude Code
  --codex    Install for Codex only
  --claude   Install for Claude Code only
  -h, --help Show help

Default: --all
USAGE
}

case "${1:---all}" in
  --all)
    install_codex
    install_claude
    ;;
  --codex)
    install_codex
    ;;
  --claude)
    install_claude
    ;;
  -h|--help)
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac
