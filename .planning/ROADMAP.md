# Roadmap: dotfiles

**Created:** 2026-04-22
**Granularity:** coarse
**Mode:** YOLO
**Total v1 Requirements:** 47
**Coverage:** 47/47 mapped

## Core Value

Running `./install.sh` on a fresh macOS install produces a fully working development environment without manual intervention.

## Phases

- [x] **Phase 1: Capture** - Snapshot the current Mac (Brewfile, mas list, shell, git, tool configs) into the repo (completed 2026-04-22)
- [x] **Phase 2: Sanitize & Safety Net** - Strip secrets and P&P identity, add `.env.example`, `.gitignore`, secret-scan script (completed 2026-04-22)
- [ ] **Phase 3: macOS Defaults & Stow Layout** - Curated `defaults.sh` and finalized GNU stow module structure
- [ ] **Phase 4: Install Script & Documentation** - Bash `install.sh`, README, LICENSE, post-install checklist, fresh-machine verification

## Phase Details

### Phase 1: Capture
**Goal**: The committed repo contains a complete, lossless snapshot of the source machine's package state and dotfile content.
**Depends on**: Nothing (first phase)
**Requirements**: PKG-01, PKG-02, PKG-03, PKG-04, SHELL-01, SHELL-02, SHELL-03, GIT-01, GIT-02, CFG-01, CFG-02, CFG-03, CFG-04, CFG-05
**Success Criteria** (what must be TRUE):
  1. `Brewfile` exists at the repo root and contains all 28 taps, 274 formulae, and 26 casks from the source machine
  2. `Brewfile` contains all 9 `mas` entries with their numeric App Store IDs
  3. `.zshrc`, `.zprofile`, and every `.zsh.d/*.zsh` module are copied into the repo (raw, pre-sanitization is OK at this point)
  4. `.gitconfig` is captured along with the user's existing `init.defaultBranch = main` setting
  5. Tool configs under `~/.config/{htop,iterm2,git,opencode,Claude,tfenv,packer,stripe}` are copied into corresponding stow module directories
**Plans**: TBD

### Phase 2: Sanitize & Safety Net
**Goal**: Every committed file is safe to publish to a public GitHub remote — no secrets, no company identity, no leaked machine-local state.
**Depends on**: Phase 1
**Requirements**: SHELL-02 (sanitize), SHELL-05, SHELL-06, CFG-06, PUB-01, PUB-02, PUB-03, PUB-04, PUB-05
**Success Criteria** (what must be TRUE):
  1. `grep -ri "pixelandprocess" .` returns no results in committed files
  2. `grep -ri "FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=.\+" .` finds only `.env.example` placeholders, never real values
  3. `.env.example` exists at the repo root and documents every secret env var the shell expects (with placeholder values)
  4. `.gitignore` blocks `.env`, `.env.local`, `*.pem`, `id_rsa*`, `*.key`, and shell history files
  5. `scripts/scan-secrets.sh` exists, is executable, and exits non-zero if known secret prefixes appear in any tracked file
  6. `exports.zsh` sources `~/.env.local` if present and silently no-ops otherwise
**Plans**: TBD

### Phase 3: macOS Defaults & Stow Layout
**Goal**: The repo can deterministically reshape a vanilla macOS user environment via curated defaults and per-tool stow modules.
**Depends on**: Phase 2
**Requirements**: MAC-01, MAC-02, MAC-03, MAC-04, MAC-05, MAC-06, MAC-07, STOW-01, STOW-02, STOW-03, STOW-04
**Success Criteria** (what must be TRUE):
  1. `macos/defaults.sh` runs end-to-end without errors and is safe to re-run (idempotent `defaults write` calls)
  2. `defaults.sh` covers Finder (hidden files, extensions, no .DS_Store on network), Dock (autohide, no recents, smaller icons), keyboard (fast key repeat, no press-and-hold), screenshots (~/Screenshots, PNG), and screensaver/lock
  3. `defaults.sh` restarts Dock, Finder, and SystemUIServer at the end so changes take effect without logout
  4. `stow/` contains one directory per tool (zsh, git, htop, iterm2, opencode, etc.) and each module mirrors its target `$HOME` layout
  5. `make stow` (or `./scripts/stow-all.sh`) symlinks every module into `$HOME` cleanly; `make unstow` removes every link with no leftovers
  6. Each stow module has a `.stow-local-ignore` excluding `.DS_Store`, `README*`, and module-specific machine-local paths
**Plans**: TBD

### Phase 4: Install Script & Documentation
**Goal**: A first-time user (or the author on a fresh Mac) can clone the repo, run `./install.sh`, and end up with a fully provisioned development environment — with the README explaining everything else they need to do.
**Depends on**: Phase 3
**Requirements**: PKG-05, SHELL-04, INST-01, INST-02, INST-03, INST-04, INST-05, INST-06, INST-07, INST-08, INST-09, INST-10, INST-11, INST-12, INST-13, DOC-01, DOC-02, DOC-03, DOC-04, DOC-05, DOC-06
**Success Criteria** (what must be TRUE):
  1. `./install.sh --dry-run` runs to completion on the source machine and prints every action it would take, changing nothing
  2. `./install.sh` (live) on a fresh macOS VM/clean user installs CLT, Homebrew, runs `brew bundle`, clones oh-my-zsh, stows all modules, applies macOS defaults, sets zsh as login shell, and exits 0
  3. `install.sh` detects Apple Silicon vs Intel and uses the correct Homebrew prefix (`/opt/homebrew` vs `/usr/local`)
  4. Re-running `./install.sh` on an already-provisioned machine completes in seconds and changes nothing destructive
  5. `install.sh` prints a post-install checklist at the end (sign in to App Store, populate `~/.env.local`, import SSH/GPG keys, restart shell)
  6. `README.md` documents purpose, one-line bootstrap command, directory layout, post-install checklist, and how to update the Brewfile
  7. `LICENSE` (MIT) exists at the repo root
**Plans**: TBD

## Progress Table

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Capture | 3/3 | Complete    | 2026-04-22 |
| 2. Sanitize & Safety Net | 1/1 | Complete    | 2026-04-22 |
| 3. macOS Defaults & Stow Layout | 0/TBD | Not started | - |
| 4. Install Script & Documentation | 0/TBD | Not started | - |

## Coverage Map

| Requirement | Phase |
|-------------|-------|
| PKG-01 | 1 |
| PKG-02 | 1 |
| PKG-03 | 1 |
| PKG-04 | 1 |
| PKG-05 | 4 |
| SHELL-01 | 1 |
| SHELL-02 | 1 (capture) + 2 (sanitize) |
| SHELL-03 | 1 |
| SHELL-04 | 4 |
| SHELL-05 | 2 |
| SHELL-06 | 2 |
| GIT-01 | 1 |
| GIT-02 | 1 |
| CFG-01 | 1 |
| CFG-02 | 1 |
| CFG-03 | 1 |
| CFG-04 | 1 |
| CFG-05 | 1 |
| CFG-06 | 2 |
| MAC-01 | 3 |
| MAC-02 | 3 |
| MAC-03 | 3 |
| MAC-04 | 3 |
| MAC-05 | 3 |
| MAC-06 | 3 |
| MAC-07 | 3 |
| STOW-01 | 3 |
| STOW-02 | 3 |
| STOW-03 | 3 |
| STOW-04 | 3 |
| INST-01 | 4 |
| INST-02 | 4 |
| INST-03 | 4 |
| INST-04 | 4 |
| INST-05 | 4 |
| INST-06 | 4 |
| INST-07 | 4 |
| INST-08 | 4 |
| INST-09 | 4 |
| INST-10 | 4 |
| INST-11 | 4 |
| INST-12 | 4 |
| INST-13 | 4 |
| PUB-01 | 2 |
| PUB-02 | 2 |
| PUB-03 | 2 |
| PUB-04 | 2 |
| PUB-05 | 2 |
| DOC-01 | 4 |
| DOC-02 | 4 |
| DOC-03 | 4 |
| DOC-04 | 4 |
| DOC-05 | 4 |
| DOC-06 | 4 |

**Coverage:** 47/47 v1 requirements mapped. SHELL-02 is intentionally addressed across two phases (capture in Phase 1, sanitize in Phase 2) because the capture/sanitize split is the core sequencing of this project; for traceability accounting it lives primarily in Phase 2 (where it must be TRUE).

---
*Roadmap created: 2026-04-22*
