#!/bin/sh
# Dev/symlink install: links the flamingo skill into ~/.claude/skills so it is
# available in every Claude Code session as /flamingo and updates with git pull.
# For the plugin-managed alternative, see README.md (Installation).
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TARGET="$HOME/.claude/skills/flamingo"

if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
  echo "error: $TARGET exists and is not a symlink — remove it first." >&2
  exit 1
fi

mkdir -p "$HOME/.claude/skills"
ln -sfn "$REPO_DIR/skills/flamingo" "$TARGET"
echo "Linked $TARGET -> $REPO_DIR/skills/flamingo"
echo "Open a new Claude Code session and run: /flamingo <your idea>"
