#!/usr/bin/env bash
# Install flux-delegation and flux-loop into ~/.claude/skills/
set -euo pipefail

DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$DEST"
for skill in flux-delegation flux-loop; do
  if [ -e "$DEST/$skill" ]; then
    read -r -p "$DEST/$skill exists. Overwrite? [y/N] " ans
    [ "$ans" = "y" ] || [ "$ans" = "Y" ] || { echo "skip $skill"; continue; }
    rm -rf "$DEST/$skill"
  fi
  cp -R "$SRC/$skill" "$DEST/$skill"
  echo "installed $skill -> $DEST/$skill"
done

echo "Done. Start a new Claude Code session to load them."
