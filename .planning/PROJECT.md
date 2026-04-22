# dotfiles

## What This Is

A personal dotfiles repository that captures Florian Wartner's macOS development environment — Homebrew taps/formulae/casks, Mac App Store apps, shell configuration, tool configs, and curated macOS defaults — with a single `install.sh` that provisions a new Mac into a 1:1 clone of the source machine.

## Core Value

Running `./install.sh` on a fresh macOS install must produce a fully working development environment without manual intervention. If anything else breaks, this must not.

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

(None yet — ship to validate)

### Active

<!-- Current scope. Building toward these. -->

- [ ] **PKG-01**: Brewfile captures every installed tap, formula, and cask from the source machine
- [ ] **PKG-02**: `mas` list captures every installed Mac App Store app with its numeric ID
- [ ] **SHELL-01**: `.zshrc`, `.zprofile`, `.zsh.d/*.zsh`, oh-my-zsh plugin/theme selection are versioned
- [ ] **SHELL-02**: All P&P-specific identity and Fastlane secrets stripped from committed files
- [ ] **SHELL-03**: `.env.example` documents the secret env vars the shell expects (real values live in gitignored `~/.zshenv` or `~/.env.local`)
- [ ] **GIT-01**: `.gitconfig` captured with a generic (non-P&P) identity
- [ ] **CFG-01**: Relevant `~/.config/*` tool configs captured (htop, gh, iterm2, opencode, tfenv, git, packer, patrol_cli, prjct, stripe, etc.) — excluding caches, credentials, session stores
- [ ] **CFG-02**: Machine-local state paths (gcloud creds, hcloud tokens, containers state, psysh history, etc.) explicitly excluded
- [ ] **MAC-01**: `macos/defaults.sh` applies sensible developer defaults (hidden files, fast key repeat, screenshots folder, Finder, Dock, etc.) — curated, not a full mirror
- [ ] **STOW-01**: All home-directory dotfiles linked via GNU stow modules (one directory per tool)
- [ ] **INST-01**: `install.sh` is idempotent — re-running on a provisioned machine is safe and fast
- [ ] **INST-02**: `install.sh` installs Xcode Command Line Tools, Homebrew, runs `brew bundle`, runs `mas install`, stows dotfiles, applies macOS defaults
- [ ] **INST-03**: `install.sh` works on both Apple Silicon and Intel Macs (conditional brew prefix)
- [ ] **DOC-01**: README explains what the repo does, how to bootstrap a new machine, and what to do post-install (sign in to App Store, import SSH keys, populate `.env.local`)
- [ ] **PUB-01**: Repo is safe to publish publicly — no secrets, no SSH keys, no @pixelandprocess.de references, no GPG private material

### Out of Scope

<!-- Explicit boundaries. Includes reasoning to prevent re-adding. -->

- SSH private keys and `~/.ssh/config` — personal credentials, never committed even in a public repo
- GPG private keys in `~/.gnupg/private-keys-v1.d/` — same rationale
- Any file under `~/.config/gcloud`, `~/.config/hcloud`, `~/.config/gh` access tokens — active session credentials
- Pixel & Process company tooling, agents, or identity — user directive
- iCloud-synced application preferences (Xcode, Sketch, etc.) — handled by iCloud on sign-in
- Browser extensions and profiles — handled by browser sync, not worth versioning
- Application support data (Herd config, lmstudio models, ollama models) — too large, app re-fetches on launch
- `~/Projects` and source code repos — tracked in their own git remotes
- Every macOS `defaults` key from every domain — brittle and noisy; curated subset only

## Context

- **OS:** macOS 26.3.1 (Tahoe), Apple Silicon (arm64), Darwin 25.3.0
- **Shell:** zsh with oh-my-zsh, spaceship theme, custom `$HOME/.zsh.d` module layout (exports → aliases → functions → laravel → docker → flutter → k8s → infra)
- **Package state at capture:**
  - Homebrew: 28 taps, 274 formulae, 26 casks
  - Mac App Store: 9 apps (Amphetamine, Gyroflow, Home Assistant, Photomator, Pixelmator Pro, SSH Config Editor, Telegram, WireGuard, Xcode)
- **Existing shell hygiene:** `.zsh.d` is already modular and conditional (`(( ${+commands[X]} ))`), which makes it easy to port without breakage. The only sensitive contents are a Fastlane application-specific password and a `@pixelandprocess.de` email.
- **Tool managers in play:** nvm (Herd-managed), rbenv, tfenv, pipx, rustup, bun, Herd (PHP). The install script must allow these to coexist.
- **Dotfiles management approach chosen:** GNU stow (already installed via brew), so the repo layout mirrors `$HOME` under topic directories.

## Constraints

- **Tech stack**: Bash (not zsh) for `install.sh` — portable, works during bootstrap before zsh customizations are loaded
- **Compatibility**: Must run on a vanilla macOS install (no tools pre-installed other than whatever Apple ships)
- **Security**: Repo is intended for a **public** GitHub remote — every committed file must be safe to publish; no tokens, no `@pixelandprocess.de`, no Fastlane secrets
- **Idempotence**: Every script step must be safe to re-run (brew install skips installed packages; stow re-links cleanly; defaults writes are declarative)
- **No company identity**: All references to Pixel & Process, `pixelandprocess.de`, and P&P-specific paths/agents/tools must be excluded

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| GNU stow for symlink management | Already installed, standard approach, per-tool modularity, clean uninstall | — Pending |
| Strip secrets → `.env.example` | Repo is public; real values live in gitignored `~/.env.local` sourced from `.zshenv` | — Pending |
| Sensible macOS defaults, not a full mirror | `defaults export` output is brittle and noisy; a curated list is readable and maintainable | — Pending |
| Bash for `install.sh` | zsh isn't available during initial bootstrap on a fresh machine until Homebrew installs it | — Pending |
| Use `brew bundle` with a Brewfile | Native Homebrew workflow; handles taps, formulae, casks, and `mas` entries in one file | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-22 after initialization*
