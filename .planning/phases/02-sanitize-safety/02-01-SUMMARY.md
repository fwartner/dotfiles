---
phase: 02-sanitize-safety
plan: 01
status: complete
requirements: [SHELL-02, SHELL-05, SHELL-06, CFG-06, PUB-01, PUB-02, PUB-03, PUB-04, PUB-05]
files_modified:
  - /Users/fwartner/dotfiles/stow/zsh/.zsh.d/exports.zsh
  - /Users/fwartner/dotfiles/.env.example
  - /Users/fwartner/dotfiles/.gitignore
  - /Users/fwartner/dotfiles/scripts/scan-secrets.sh
  - /Users/fwartner/dotfiles/Brewfile
---

## Summary

Stripped Pixel & Process identity and hardcoded secrets, added the `~/.env.local` mechanism, wrote `.gitignore` and `scripts/scan-secrets.sh`, and removed two P&P-flavored Brewfile entries.

## Changes

**`stow/zsh/.zsh.d/exports.zsh`:**
- Added `[[ -f "$HOME/.env.local" ]] && source "$HOME/.env.local"` at the top
- Replaced hardcoded `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="jnjx-xtxh-rwnd-kqkp"` with `"${FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD:-}"`
- Replaced `FASTLANE_USER="florian@pixelandprocess.de"` with `"${FASTLANE_USER:-}"`

**`.env.example` (new):** Documents `FASTLANE_USER` and `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` with placeholder values and copy-to-`.env.local` instructions.

**`.gitignore` (new):** Blocks `.env`, `.env.local`, SSH keys (`id_rsa*`, `id_ed25519*`), TLS keys (`*.pem`, `*.key`, `*.p12`, `*.pfx`), shell history files, OS files (`.DS_Store`), editor files, and the install marker `.installed`.

**`scripts/scan-secrets.sh` (new):** Greps tracked files for 12 patterns:
- Stripe live keys (`sk_live_`, `rk_live_`)
- AWS access keys (`AKIA...`)
- GitHub tokens (`ghp_`, `ghs_`, `gho_`, etc.)
- Slack tokens (`xox[baprs]-`)
- Generic API key headers
- OpenAI keys (`sk-...`)
- PEM private key headers
- Apple app-specific password (only when assigned to `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`)
- `@pixelandprocess.de` email
- `pixelandprocess.de` domain

Excludes `CLAUDE.md` (documents the rule), `README.md`, `.env.example`, `.planning/`, and itself.

**`Brewfile` (P&P removal):**
- Removed `brew "fwartner/tap/pnp"` and its `# Pixel & Process Kubernetes deployment manager` comment
- Removed `vscode "highagency.pencildev"` (Pencil — P&P-related)
- Kept `tap "fwartner/tap"` and `brew "fwartner/tap/prjct"` (prjct is a generic project-scaffolding tool, not P&P)

**Cask count after removal:** 26 → 26 (unchanged — only formula and vscode entries removed)

## Verification

```
$ bash scripts/scan-secrets.sh
✓ Secret scan passed (16 files, 12 patterns).

$ grep -rn -i "pixelandprocess\|pixel.*process" stow/ Brewfile .env.example .gitignore
(no output)
```

## Acceptance Criteria

- [x] SHELL-02: `exports.zsh` no longer contains the literal Fastlane password
- [x] SHELL-05: `.env.example` exists, documents both Fastlane vars
- [x] SHELL-06: `exports.zsh` sources `~/.env.local` if present, no-ops otherwise
- [x] CFG-06: caches/sessions/credentials excluded by `.gitignore` and stow capture decisions (Phase 1)
- [x] PUB-01: no SSH/GPG keys, no API tokens, no `.env`, no shell history committed
- [x] PUB-02: no `@pixelandprocess.de` references in committed files
- [x] PUB-03: P&P-specific `brew "fwartner/tap/pnp"` and `vscode "highagency.pencildev"` removed
- [x] PUB-04: `.gitignore` blocks `.env`, `.env.local`, `*.pem`, `id_rsa*`, `*.key` and history files
- [x] PUB-05: `scripts/scan-secrets.sh` exists, executable, exits non-zero on known patterns
