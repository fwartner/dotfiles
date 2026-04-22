# oh-my-zsh custom

This directory is symlinked into `~/.oh-my-zsh/custom/`.

Anything you drop here is auto-loaded by oh-my-zsh after its built-in init:

- `*.zsh` files at the top level → sourced alphabetically (good for overrides)
- `plugins/<name>/<name>.plugin.zsh` → activate with `plugins=(<name>)` in `~/.zshrc`
- `themes/<name>.zsh-theme` → activate with `ZSH_THEME="<name>"` in `~/.zshrc`

After adding files, run `make restow` from the repo root to refresh symlinks.

## Note on stock examples

oh-my-zsh ships three stock example files at install:
`example.zsh`, `plugins/example/example.plugin.zsh`, `themes/example.zsh-theme`.
`install.sh` removes those before stowing so this module can take over the dir cleanly.
If oh-my-zsh's auto-updater ever recreates them, run `make restow` to fix.

## Current state

Empty (no custom plugins or themes). The active zsh config lives in `stow/zsh/.zsh.d/`
and is sourced from `~/.zshrc` directly, not via this dir.
