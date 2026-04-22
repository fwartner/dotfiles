#!/usr/bin/env bash
# stow-all.sh - Symlink every stow module into $HOME.
#
# Usage:
#   ./scripts/stow-all.sh           # link everything
#   ./scripts/stow-all.sh --dry-run # show what would happen
#   ./scripts/stow-all.sh --unstow  # remove all symlinks

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
case "${1:-}" in
  --unstow)  ACTION_FLAG="-D" ;;
  --dry-run) ACTION_FLAG="-n -v" ;;
  --restow)  ACTION_FLAG="-R" ;;
  "")        ACTION_FLAG="-v" ;;
  *)
    echo "Usage: $0 [--dry-run | --unstow | --restow]" >&2
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

# shellcheck disable=SC2086
stow --target="$HOME" $ACTION_FLAG "${modules[@]}"

echo ""
echo "✓ stow-all complete (${1:-link})"
