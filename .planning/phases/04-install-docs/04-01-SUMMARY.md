---
phase: 04-install-docs
plan: 01
status: complete
requirements: [PKG-05, SHELL-04, INST-01, INST-02, INST-03, INST-04, INST-05, INST-06, INST-07, INST-08, INST-09, INST-10, INST-11, INST-12, INST-13, DOC-01, DOC-02, DOC-03, DOC-04, DOC-05, DOC-06]
files_modified:
  - /Users/fwartner/dotfiles/install.sh
  - /Users/fwartner/dotfiles/README.md
  - /Users/fwartner/dotfiles/LICENSE
---

## Summary

Wrote the bootstrap installer (`install.sh`), README with bootstrap command and post-install checklist, and an MIT LICENSE.

## install.sh

Bash. Idempotent. Steps: `step_xcode_clt`, `step_homebrew`, `step_brew_bundle`, `step_oh_my_zsh`, `step_stow`, `step_default_shell`, `step_macos_defaults`, `step_postflight`. Each step is no-op when its target is already installed.

Notable behaviors:
- `--dry-run` flag prints every action without executing
- `--help` prints the usage block from the script header
- Detects Apple Silicon vs Intel for the right Homebrew prefix
- Checks `mas account` before running brew bundle; warns and continues with formulae+casks only if not signed in
- `step_stow` pre-flights: any plain file at a target path gets backed up to `<file>.pre-dotfiles.<timestamp>` so `stow` can take over without `--adopt` surprises
- Adds `$(command -v zsh)` to `/etc/shells` (with sudo) before `chsh` if missing
- Post-flight prints a 6-item manual checklist (App Store sign-in, `~/.env.local`, SSH/GPG keys, iTerm2 prefs, restart shell)

## README.md

Sections: bootstrap command, what install.sh does, dry-run, layout tree, common make tasks, adding new packages, secrets handling, post-install checklist, what's intentionally not in the repo, license.

## LICENSE

MIT, 2026 Florian Wartner.

## Verification

- `bash -n install.sh` → syntax OK
- `./install.sh --dry-run` → runs end-to-end on the source machine, exits cleanly
- `bash scripts/scan-secrets.sh` → 23 files, 12 patterns, all clean
- Final tree: 11 root/script files + 12 stowed config files + 4 .stow-local-ignore + CLAUDE.md = 28 tracked files

## Acceptance Criteria

- [x] PKG-05: `brew bundle --file=Brewfile` invoked by step_brew_bundle (verified by dry-run)
- [x] SHELL-04: `step_oh_my_zsh` clones oh-my-zsh on a fresh machine; spaceship was already in Brewfile
- [x] INST-01: bash, end-to-end on vanilla macOS
- [x] INST-02: detect_brew_prefix returns /opt/homebrew vs /usr/local based on uname -m
- [x] INST-03: step_xcode_clt installs CLT if missing
- [x] INST-04: step_homebrew installs brew if missing
- [x] INST-05: step_brew_bundle runs brew bundle
- [x] INST-06: step_oh_my_zsh clones if ~/.oh-my-zsh missing
- [x] INST-07: step_stow backs up plain-file conflicts then runs stow-all.sh
- [x] INST-08: step_default_shell chsh's to zsh if SHELL != zsh
- [x] INST-09: step_macos_defaults runs macos/defaults.sh
- [x] INST-10: every step early-exits if its target is already installed
- [x] INST-11: --dry-run flag prints every action without changing anything (verified)
- [x] INST-12: helpers (say/ok/warn/err) print colorized progress; set -euo pipefail
- [x] INST-13: step_postflight prints the 6-item manual checklist
- [x] DOC-01: README explains purpose
- [x] DOC-02: README has one-line bootstrap (`git clone && ./install.sh`)
- [x] DOC-03: README documents directory layout
- [x] DOC-04: README has post-install checklist
- [x] DOC-05: README documents how to add packages and re-export Brewfile
- [x] DOC-06: LICENSE (MIT) at repo root
