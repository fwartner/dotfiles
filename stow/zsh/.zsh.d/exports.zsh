# All export statements — no aliases, functions, or source calls.
# Source this first so PATH and env vars are available to other config.

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Herd PHP configuration
export HERD_PHP_84_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/84/"
export HERD_PHP_85_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/85/"
export HERD_PHP_83_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/83/"

# Herd NVM
export NVM_DIR="$HOME/Library/Application Support/Herd/config/nvm"

# PATH additions (Herd bin, Antigravity)
export PATH="$HOME/Library/Application Support/Herd/bin/:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Fastlane (consider not committing secrets to a public repo)
export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="jnjx-xtxh-rwnd-kqkp"
export FASTLANE_USER="florian@pixelandprocess.de"

# Editor (used by zshconfig, git, etc.)
export EDITOR="${EDITOR:-nano}"

# Bat theme (syntax-highlighted cat)
export BAT_THEME="${BAT_THEME:-base16}"

# Direnv (quiet log format)
export DIRENV_LOG_FORMAT=""
