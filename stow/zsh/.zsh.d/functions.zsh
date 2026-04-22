# General helper functions

# Reload full zsh config (~/.zshrc)
# Unalias first in case OMZ or another plugin defined it
unalias reload 2>/dev/null
reload() {
  source ~/.zshrc && echo "Zsh config reloaded."
}

# Reload only custom config (exports, aliases, functions, laravel, docker, flutter, k8s, infra)
# Use after editing ~/.zsh.d without re-running OMZ/brew/etc.
zshreload-custom() {
  local dir="${ZSH_CUSTOM_DIR:-$HOME/.zsh.d}"
  for f in exports aliases functions laravel docker flutter k8s infra; do
    [[ -f "$dir/$f.zsh" ]] && source "$dir/$f.zsh" || true
  done
  echo "Custom zsh config reloaded ($dir)."
}

# Check .zshrc and custom *.zsh for syntax errors
zshconfig-check() {
  local err=0
  echo "Checking ~/.zshrc ..."
  zsh -n ~/.zshrc 2>&1 || { err=1; }
  local dir="${ZSH_CUSTOM_DIR:-$HOME/.zsh.d}"
  for f in "$dir"/*.zsh(N); do
    echo "Checking $f ..."
    zsh -n "$f" 2>&1 || err=1
  done
  if (( err == 0 )); then
    echo "All checks passed."
  else
    return 1
  fi
}

# Create directory and cd into it
mkd() {
  mkdir -p "$1" && cd "$1"
}

# Extract archives (tar.gz, tar.bz2, zip, etc.)
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.gz|*.tgz)  tar xzf "$1" ;;
      *.tar.bz2|*.tbz2) tar xjf "$1" ;;
      *.tar.xz)        tar xJf "$1" ;;
      *.tar)            tar xf "$1" ;;
      *.zip|*.ZIP)      unzip "$1" ;;
      *.gz)             gunzip -k "$1" ;;
      *.bz2)            bunzip2 -k "$1" ;;
      *)                echo "Unknown archive type: $1" ; return 1 ;;
    esac
  else
    echo "Usage: extract <file>"
    return 1
  fi
}

# Tree with limited depth (default 2)
tre() {
  tree -L "${1:-2}" -a
}

# List processes listening on ports
ports() {
  if command -v lsof &>/dev/null; then
    lsof -i -P -n | grep LISTEN
  else
    echo "lsof not found"
    return 1
  fi
}

# Pretty-print JSON from stdin (requires jq)
json() {
  if (( ${+commands[jq]} )); then
    jq .
  else
    echo "jq not found. Install with: brew install jq" >&2
    return 1
  fi
}

# Kill process listening on port
killport() {
  if [[ -z "$1" ]]; then
    echo "Usage: killport <port>"
    return 1
  fi
  local pids
  pids=$(lsof -ti ":$1" 2>/dev/null)
  if [[ -z "$pids" ]]; then
    echo "No process listening on port $1"
    return 1
  fi
  echo "Killing process(es) on port $1: $pids"
  echo "$pids" | xargs kill -9
}

# macOS notification (requires terminal-notifier)
notify() {
  if (( ${+commands[terminal-notifier]} )); then
    terminal-notifier -message "${*:-Done}"
  else
    echo "terminal-notifier not found. Install with: brew install terminal-notifier" >&2
    return 1
  fi
}

# Weather (wttr.in)
weather() {
  local q="${1:-}"
  curl -s "https://wttr.in/${q}"
}
