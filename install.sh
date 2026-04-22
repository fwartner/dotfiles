#!/usr/bin/env bash
# install.sh - Bootstrap a fresh macOS into a 1:1 clone of this dotfiles repo.
#
# Idempotent: safe to re-run on a provisioned machine.
# Bash (not zsh) so it runs during initial bootstrap before any zsh customizations.
#
# Usage:
#   ./install.sh           # full install
#   ./install.sh --dry-run # show what would happen, change nothing
#   ./install.sh --help    # this message

set -euo pipefail

###############################################################################
# CLI
###############################################################################
DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help)
      sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "Unknown flag: $arg" >&2
      exit 2
      ;;
  esac
done

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

###############################################################################
# Helpers
###############################################################################
say()  { printf '\n\033[1;34m▶\033[0m %s\n' "$*"; }
ok()   { printf '  \033[1;32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[1;33m!\033[0m %s\n' "$*"; }
err()  { printf '  \033[1;31m✗\033[0m %s\n' "$*" >&2; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '  [dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

require_macos() {
  if [ "$(uname)" != "Darwin" ]; then
    err "This installer only supports macOS. Detected: $(uname)"
    exit 1
  fi
}

detect_brew_prefix() {
  if [ "$(uname -m)" = "arm64" ]; then
    echo "/opt/homebrew"
  else
    echo "/usr/local"
  fi
}

###############################################################################
# Steps
###############################################################################

step_xcode_clt() {
  say "Xcode Command Line Tools"
  if xcode-select -p >/dev/null 2>&1; then
    ok "already installed at $(xcode-select -p)"
    return
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '  [dry-run] xcode-select --install\n'
    return
  fi
  warn "installing — accept the GUI prompt that appears, then re-run this script"
  xcode-select --install || true
  exit 0
}

step_homebrew() {
  say "Homebrew"
  if command -v brew >/dev/null 2>&1; then
    ok "already installed at $(command -v brew)"
    return
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '  [dry-run] /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\n'
    return
  fi
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  local prefix; prefix=$(detect_brew_prefix)
  eval "$($prefix/bin/brew shellenv)"
}

step_brew_bundle() {
  say "Brewfile (taps, formulae, casks, mas)"
  if [ ! -f "$ROOT/Brewfile" ]; then
    err "Brewfile missing at $ROOT/Brewfile"
    exit 1
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '  [dry-run] brew bundle --file=%s\n' "$ROOT/Brewfile"
    return
  fi

  if ! brew list mas >/dev/null 2>&1; then
    warn "mas not installed — installing first so MAS apps can be fetched"
    brew install mas
  fi
  if ! mas account >/dev/null 2>&1; then
    warn "Not signed in to the Mac App Store. Sign in via the App Store app, then re-run."
    warn "Continuing with formulae and casks only — mas entries will be skipped this run."
  fi

  brew bundle --file="$ROOT/Brewfile"
  ok "brew bundle complete"
}

step_oh_my_zsh() {
  say "oh-my-zsh"
  if [ -d "$HOME/.oh-my-zsh" ]; then
    ok "already installed"
  else
    if [ "$DRY_RUN" -eq 1 ]; then
      printf '  [dry-run] install oh-my-zsh\n'
    else
      RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended
    fi
  fi

  # Remove OMZ's stock example files so stow/oh-my-zsh can take over custom/ cleanly
  local omz_custom="$HOME/.oh-my-zsh/custom"
  if [ -d "$omz_custom" ]; then
    for stock in "$omz_custom/example.zsh" "$omz_custom/themes/example.zsh-theme"; do
      if [ -f "$stock" ] && [ ! -L "$stock" ]; then
        run rm -f "$stock"
      fi
    done
    if [ -d "$omz_custom/plugins/example" ] && [ ! -L "$omz_custom/plugins/example" ]; then
      run rm -rf "$omz_custom/plugins/example"
    fi
  fi
}

step_stow() {
  say "GNU stow → \$HOME"
  if ! command -v stow >/dev/null 2>&1; then
    err "stow not installed (brew bundle should have installed it). Run brew install stow."
    exit 1
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '  [dry-run] ./scripts/stow-all.sh --dry-run\n'
    "$ROOT/scripts/stow-all.sh" --dry-run || true
    return
  fi

  # Pre-flight: if any target is a real file (not a symlink), back it up so stow can take over.
  cd "$ROOT/stow"
  for module in */; do
    while IFS= read -r relpath; do
      target="$HOME/$relpath"
      if [ -e "$target" ] && [ ! -L "$target" ]; then
        bak="$target.pre-dotfiles.$(date +%Y%m%d-%H%M%S)"
        warn "backing up existing $target -> $bak"
        mv "$target" "$bak"
      fi
    done < <(cd "$module" && find . -type f -not -name '.stow-local-ignore' | sed 's|^\./||')
  done
  cd "$ROOT"

  "$ROOT/scripts/stow-all.sh"
  ok "stow complete"
}

step_default_shell() {
  say "Default login shell (zsh)"
  local zsh_path
  zsh_path="$(command -v zsh)"
  if [ "${SHELL:-}" = "$zsh_path" ]; then
    ok "already zsh ($SHELL)"
    return
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '  [dry-run] chsh -s %s\n' "$zsh_path"
    return
  fi
  if ! grep -qx "$zsh_path" /etc/shells; then
    warn "$zsh_path not in /etc/shells — adding (sudo required)"
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$zsh_path"
}

step_macos_defaults() {
  say "macOS defaults"
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '  [dry-run] ./macos/defaults.sh\n'
    return
  fi
  bash "$ROOT/macos/defaults.sh"
}

step_postflight() {
  say "Post-install checklist"
  cat <<'EOF'

Manual steps that this script can't (or shouldn't) automate:

  1. Sign in to the Mac App Store, then re-run `brew bundle` if mas apps were skipped:
       open -a "App Store"
       brew bundle --file=Brewfile

  2. Copy your secrets file:
       cp .env.example ~/.env.local && chmod 600 ~/.env.local
       $EDITOR ~/.env.local        # fill in real values

  3. Import SSH keys from your secure storage into ~/.ssh/  (chmod 700 ~/.ssh, 600 keys)

  4. Import GPG keys (if you sign commits):
       gpg --import path/to/private.key

  5. iTerm2 preferences (optional):
       Settings → General → Preferences → Load preferences from a custom folder
       Point at: <somewhere you sync, e.g. iCloud Drive>

  6. Restart your shell so the new zsh + stowed config kick in:
       exec zsh -l

EOF
}

###############################################################################
# Main
###############################################################################
require_macos

if [ "$DRY_RUN" -eq 1 ]; then
  warn "DRY RUN — no changes will be made"
fi

step_xcode_clt
step_homebrew
step_brew_bundle
step_oh_my_zsh
step_stow
step_default_shell
step_macos_defaults
step_postflight

say "Done."
ok "Run 'exec zsh -l' to start using the new environment."
