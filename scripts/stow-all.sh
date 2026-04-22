#!/usr/bin/env bash
# stow-all.sh - Symlink every stow module into $HOME.
#
# Usage:
#   ./scripts/stow-all.sh             # link everything (auto-backup conflicts)
#   ./scripts/stow-all.sh --dry-run   # show what would happen
#   ./scripts/stow-all.sh --unstow    # remove all symlinks
#   ./scripts/stow-all.sh --restow    # refresh all symlinks
#   ./scripts/stow-all.sh --no-backup # fail on conflicts instead of backing up

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STOW_DIR="$ROOT/stow"

if ! command -v stow >/dev/null 2>&1; then
  echo "✗ GNU stow not installed. Install with: brew install stow" >&2
  exit 1
fi

if [ ! -d "$STOW_DIR" ]; then
  echo "✗ Stow source dir not found: $STOW_DIR" >&2
  exit 1
fi

ACTION_FLAG=""
BACKUP=1
case "${1:-}" in
  --unstow)    ACTION_FLAG="-D"; BACKUP=0 ;;
  --dry-run)   ACTION_FLAG="-n -v"; BACKUP=0 ;;
  --restow)    ACTION_FLAG="-R" ;;
  --no-backup) ACTION_FLAG="-v"; BACKUP=0 ;;
  "")          ACTION_FLAG="-v" ;;
  *)
    echo "Usage: $0 [--dry-run | --unstow | --restow | --no-backup]" >&2
    exit 2
    ;;
esac

cd "$STOW_DIR"
modules=()
for d in */; do
  modules+=("${d%/}")
done

if [ ${#modules[@]} -eq 0 ]; then
  echo "No stow modules found in $STOW_DIR"
  exit 0
fi

echo "→ stow modules: ${modules[*]}"
echo "→ target: $HOME"
echo ""

# Pre-flight: back up any existing plain file/dir that would conflict with a stowed symlink.
# Skipped for --dry-run, --unstow, and --no-backup.
if [ "$BACKUP" -eq 1 ]; then
  ts="$(date +%Y%m%d-%H%M%S)"
  backed_up=0
  for module in "${modules[@]}"; do
    while IFS= read -r relpath; do
      target="$HOME/$relpath"
      if [ -e "$target" ] && [ ! -L "$target" ]; then
        bak="$target.pre-dotfiles.$ts"
        echo "  backup: $target -> $(basename "$bak")"
        mv "$target" "$bak"
        backed_up=$((backed_up + 1))
      fi
    done < <(cd "$module" && find . -type f -not -name '.stow-local-ignore' -not -name 'README.md' | sed 's|^\./||')
  done
  if [ "$backed_up" -gt 0 ]; then
    echo "  backed up $backed_up conflicting file(s)."
    echo ""
  fi
fi

# shellcheck disable=SC2086
stow --target="$HOME" $ACTION_FLAG "${modules[@]}"

echo ""
echo "✓ stow-all complete (${1:-link})"
