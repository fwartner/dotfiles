# Requirements: dotfiles

**Defined:** 2026-04-22
**Core Value:** Running `./install.sh` on a fresh macOS install produces a fully working development environment without manual intervention.

## v1 Requirements

### Packages (PKG)

- [ ] **PKG-01**: Brewfile captures every installed Homebrew tap (28 taps at capture)
- [ ] **PKG-02**: Brewfile captures every installed Homebrew formula (274 formulae at capture)
- [ ] **PKG-03**: Brewfile captures every installed Homebrew cask (26 casks at capture)
- [ ] **PKG-04**: Brewfile includes `mas` entries for every installed Mac App Store app (9 apps at capture, with numeric IDs)
- [ ] **PKG-05**: `brew bundle --file Brewfile` reinstalls the full set on a fresh machine without errors

### Shell (SHELL)

- [ ] **SHELL-01**: `.zshrc` captured verbatim (minus secrets) and sourced from a stowed location
- [ ] **SHELL-02**: `.zprofile` captured verbatim (minus secrets) and sourced from a stowed location
- [ ] **SHELL-03**: All `.zsh.d/*.zsh` modules captured (aliases, exports, functions, laravel, docker, flutter, k8s, infra)
- [ ] **SHELL-04**: oh-my-zsh installation step in `install.sh` (cloned from upstream); spaceship theme installed via brew
- [ ] **SHELL-05**: `.env.example` documents required env vars (`FASTLANE_USER`, `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`, etc.) with placeholder values
- [ ] **SHELL-06**: `exports.zsh` reads secrets from `~/.env.local` if present, otherwise sets nothing for those vars

### Git (GIT)

- [ ] **GIT-01**: `.gitconfig` captured with generic identity (no `@pixelandprocess.de`)
- [ ] **GIT-02**: `.gitconfig` includes the user's existing `init.defaultBranch = main`

### Tool Configs (CFG)

- [ ] **CFG-01**: `~/.config/htop/htoprc` captured
- [ ] **CFG-02**: `~/.config/iterm2/` preferences captured (the .plist export)
- [ ] **CFG-03**: `~/.config/git/` files captured (ignore patterns, attributes)
- [ ] **CFG-04**: `~/.config/opencode/` and `~/.config/Claude/` non-secret config captured
- [ ] **CFG-05**: `~/.config/tfenv/`, `~/.config/packer/`, `~/.config/stripe/` (config only — no tokens) captured
- [ ] **CFG-06**: Caches, session stores, credentials, and machine-local state explicitly excluded via stow ignore patterns

### macOS Defaults (MAC)

- [ ] **MAC-01**: `macos/defaults.sh` is a curated, idempotent script (not a `defaults export` dump)
- [ ] **MAC-02**: Covers Finder (show hidden, show extensions, no .DS_Store on network)
- [ ] **MAC-03**: Covers Dock (autohide, no recents, smaller icons)
- [ ] **MAC-04**: Covers keyboard (fast key repeat, disable press-and-hold)
- [ ] **MAC-05**: Covers screenshots (folder location ~/Screenshots, PNG format)
- [ ] **MAC-06**: Covers screensaver/screen lock requirements
- [ ] **MAC-07**: Restarts affected services (Dock, Finder, SystemUIServer) after writing

### Stow Layout (STOW)

- [ ] **STOW-01**: Each tool gets its own stow module (`stow/zsh/`, `stow/git/`, `stow/htop/`, etc.)
- [ ] **STOW-02**: `make stow` (or `./scripts/stow-all.sh`) symlinks all modules into `$HOME`
- [ ] **STOW-03**: `make unstow` cleanly removes all symlinks
- [ ] **STOW-04**: Per-module `.stow-local-ignore` files exclude `.DS_Store`, `README*`, etc.

### Install Script (INST)

- [ ] **INST-01**: `install.sh` is bash (not zsh), runs end-to-end on a vanilla macOS install
- [ ] **INST-02**: Detects Apple Silicon vs Intel and uses correct Homebrew prefix
- [ ] **INST-03**: Installs Xcode Command Line Tools if missing
- [ ] **INST-04**: Installs Homebrew if missing
- [ ] **INST-05**: Runs `brew bundle --file Brewfile` (formulae + casks + mas apps)
- [ ] **INST-06**: Clones oh-my-zsh if `~/.oh-my-zsh` missing
- [ ] **INST-07**: Stows all dotfile modules into `$HOME` (with `--adopt` or pre-flight conflict detection)
- [ ] **INST-08**: Sets zsh as the default login shell if not already
- [ ] **INST-09**: Applies `macos/defaults.sh`
- [ ] **INST-10**: Idempotent — safe to re-run; skips completed steps
- [ ] **INST-11**: Has `--dry-run` flag that prints what would happen without changing anything
- [ ] **INST-12**: Logs progress with section headers; fails loudly with clear error messages
- [ ] **INST-13**: Prints post-install checklist at the end (sign in to App Store, populate `~/.env.local`, import SSH keys, restart shell)

### Public-Repo Safety (PUB)

- [ ] **PUB-01**: No SSH keys, no GPG private keys, no API tokens, no `.env`, no shell history
- [ ] **PUB-02**: No `@pixelandprocess.de` references anywhere in committed files
- [ ] **PUB-03**: No P&P-specific tools, agents, or paths (`.pixel-agents`, `.brv*`, `.pencil`, `.openclaw`, `.pnp.yaml`, etc. excluded from stow modules)
- [ ] **PUB-04**: `.gitignore` blocks common secret patterns (`.env`, `.env.local`, `*.pem`, `id_rsa*`, `*.key`)
- [ ] **PUB-05**: A pre-commit script or `scripts/scan-secrets.sh` greps for known secret prefixes

### Documentation (DOC)

- [ ] **DOC-01**: README explains the repo's purpose
- [ ] **DOC-02**: README has a one-line "bootstrap a new Mac" command (`bash <(curl -fsSL ...)` style or `git clone && ./install.sh`)
- [ ] **DOC-03**: README documents directory layout
- [ ] **DOC-04**: README has a post-install checklist
- [ ] **DOC-05**: README documents how to add/update packages and re-export the Brewfile
- [ ] **DOC-06**: LICENSE file (MIT recommended for a public dotfiles repo)

## v2 Requirements

Deferred. Acknowledged but not in current scope.

- **V2-01**: Encrypted secrets via `age` or `git-crypt` so personal env can live in the repo
- **V2-02**: Linux variant of the install script
- **V2-03**: GitHub Actions CI that runs `shellcheck` on every script
- **V2-04**: Automated drift detection (cron job that diffs current brew/mas state vs Brewfile and PRs the diff)
- **V2-05**: VSCode/Cursor settings.json and extension list

## Out of Scope

| Feature | Reason |
|---------|--------|
| SSH keys / `~/.ssh/config` | Personal credentials — never in repo |
| GPG private keys | Personal credentials — never in repo |
| Active session credentials (gcloud, hcloud, gh tokens, k8s contexts) | Per-machine state, not configuration |
| Pixel & Process tooling, agents, identity | User directive |
| iCloud-synced app prefs (Xcode user data, Sketch, etc.) | Handled by iCloud sign-in |
| Browser profiles & extensions | Handled by browser sync |
| Heavy app data (Herd config, lmstudio/ollama models, Library/Application Support/*) | Too large; apps re-fetch |
| `~/Projects` source repos | Tracked in their own remotes |
| Full `defaults export` dump | Brittle, noisy, unreviewable |
| `.zsh_history`, `.python_history`, `.wget-hsts` | Personal history, not config |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| PKG-01 | Phase 1 | Pending |
| PKG-02 | Phase 1 | Pending |
| PKG-03 | Phase 1 | Pending |
| PKG-04 | Phase 1 | Pending |
| PKG-05 | Phase 4 | Pending |
| SHELL-01 | Phase 1 | Pending |
| SHELL-02 | Phase 2 | Pending |
| SHELL-03 | Phase 1 | Pending |
| SHELL-04 | Phase 4 | Pending |
| SHELL-05 | Phase 2 | Pending |
| SHELL-06 | Phase 2 | Pending |
| GIT-01 | Phase 1 | Pending |
| GIT-02 | Phase 1 | Pending |
| CFG-01 | Phase 1 | Pending |
| CFG-02 | Phase 1 | Pending |
| CFG-03 | Phase 1 | Pending |
| CFG-04 | Phase 1 | Pending |
| CFG-05 | Phase 1 | Pending |
| CFG-06 | Phase 2 | Pending |
| MAC-01 | Phase 3 | Pending |
| MAC-02 | Phase 3 | Pending |
| MAC-03 | Phase 3 | Pending |
| MAC-04 | Phase 3 | Pending |
| MAC-05 | Phase 3 | Pending |
| MAC-06 | Phase 3 | Pending |
| MAC-07 | Phase 3 | Pending |
| STOW-01 | Phase 3 | Pending |
| STOW-02 | Phase 3 | Pending |
| STOW-03 | Phase 3 | Pending |
| STOW-04 | Phase 3 | Pending |
| INST-01 | Phase 4 | Pending |
| INST-02 | Phase 4 | Pending |
| INST-03 | Phase 4 | Pending |
| INST-04 | Phase 4 | Pending |
| INST-05 | Phase 4 | Pending |
| INST-06 | Phase 4 | Pending |
| INST-07 | Phase 4 | Pending |
| INST-08 | Phase 4 | Pending |
| INST-09 | Phase 4 | Pending |
| INST-10 | Phase 4 | Pending |
| INST-11 | Phase 4 | Pending |
| INST-12 | Phase 4 | Pending |
| INST-13 | Phase 4 | Pending |
| PUB-01 | Phase 2 | Pending |
| PUB-02 | Phase 2 | Pending |
| PUB-03 | Phase 2 | Pending |
| PUB-04 | Phase 2 | Pending |
| PUB-05 | Phase 2 | Pending |
| DOC-01 | Phase 4 | Pending |
| DOC-02 | Phase 4 | Pending |
| DOC-03 | Phase 4 | Pending |
| DOC-04 | Phase 4 | Pending |
| DOC-05 | Phase 4 | Pending |
| DOC-06 | Phase 4 | Pending |

**Coverage:**
- v1 requirements: 47 total
- Mapped to phases: 47 (100%)
- Unmapped: 0

---
*Requirements defined: 2026-04-22*
*Last updated: 2026-04-22 — traceability populated by roadmapper*
