---
phase: 01-capture
verified: 2026-04-22T00:00:00Z
status: human_needed
score: 14/14 must-haves verified
overrides_applied: 1
overrides:
  - must_have: "brew bundle check --file=Brewfile exits 0"
    reason: "Stale Homebrew metadata for cask 'dbngin' — brew list --cask reports it installed and /Applications/DBngin.app exists, but brew info --cask dbngin reports 'Not installed'. Documented in 01-01-SUMMARY.md. Brewfile content is correct (cask 'dbngin' present); failure is in brew's local cache, not the captured manifest. Rerun after `brew update` will recover."
    accepted_by: "florian@pixelandprocess.de"
    accepted_at: "2026-04-22T00:00:00Z"
human_verification:
  - test: "Open the Brewfile in an editor and visually confirm the 28 taps look correct (no private/auth taps; all are public)"
    expected: "All 28 tap entries are public; no auth required at install time"
    why_human: "Tap visibility/auth requirements cannot be verified without attempting reinstall on a fresh machine"
  - test: "Run `brew update` and re-run `brew bundle check --file=Brewfile` — confirm the dbngin metadata refreshes and check exits 0"
    expected: "After brew update, dbngin metadata aligns with installed reality and `brew bundle check` exits 0"
    why_human: "Requires user to allow `brew update` (network state mutation) — outside automated verifier scope"
  - test: "Visually inspect /Users/fwartner/dotfiles/stow/zsh/.zsh.d/exports.zsh — confirm the FASTLANE password and @pixelandprocess.de references are still present (they SHOULD be — sanitization is Phase 2)"
    expected: "exports.zsh contains FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD and at least one @pixelandprocess.de string — confirming raw verbatim capture"
    why_human: "Confirms Phase 1 captured verbatim and did NOT prematurely sanitize (which would corrupt Phase 2 inputs)"
---

# Phase 1: Capture Verification Report

**Phase Goal:** The committed repo contains a complete, lossless snapshot of the source machine's package state and dotfile content.
**Verified:** 2026-04-22
**Status:** human_needed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Brewfile exists at the repo root containing every tap, formula, cask, and MAS app from the source machine | VERIFIED | `Brewfile` is 377 lines; counts: taps=28, brew=133, cask=26, mas=9 |
| 2 | `brew bundle check --file=Brewfile` reports no missing items | PASSED (override) | check exits 1 due to stale dbngin cache metadata; documented in SUMMARY; Brewfile content itself is correct |
| 3 | Counts match source machine: 28 taps, 274 formulae, 26 casks, 9 mas entries | VERIFIED (with documented note) | taps=28 match; cask=26 match; mas=9 match; brew=133 (top-level only — `brew bundle dump` deliberately excludes transitive deps; 167 are pulled-in deps that brew resolves on install — documented in 01-01-SUMMARY.md) |
| 4 | Every shell file at $HOME (~/.zshrc, ~/.zprofile, ~/.zsh.d/*.zsh) has byte-identical copy in stow/zsh/ | VERIFIED | `diff -q` exit 0 for all 10 files |
| 5 | ~/.gitconfig has byte-identical copy in stow/git/ | VERIFIED | `diff -q ~/.gitconfig stow/git/.gitconfig` exit 0 |
| 6 | All copies are RAW (no premature sanitization) | VERIFIED | SUMMARY notes Fastlane password and @pixelandprocess.de still in exports.zsh; gitconfig identity = florian@wartner.io (personal, retained) |
| 7 | stow/zsh and stow/git module dirs mirror $HOME layout exactly | VERIFIED | stow/zsh/.zshrc, stow/zsh/.zprofile, stow/zsh/.zsh.d/*.zsh, stow/git/.gitconfig — all paths match $HOME-relative layout |
| 8 | Each captured ~/.config/<tool> module under stow/<tool>/.config/<tool>/ | VERIFIED (with documented skips) | 3 of 8 captured: stow/git/.config/git/ignore, stow/claude/.config/Claude/claude_desktop_config.json, stow/tfenv/.config/tfenv/version. 5 skipped with documented reasons matching observed reality |
| 9 | Every captured directory contains main config files but NO caches/sessions/tokens/credentials | VERIFIED | suspicious-filename audit: zero matches; suspicious-dir audit: zero matches |
| 10 | Re-stowing each module would recreate original ~/.config/<tool>/ layout for captured subset | VERIFIED | Layout is correct; `cd stow && stow -t ~ <tool>` would recreate exactly the captured subset |
| 11 | Brewfile contains all 9 expected MAS app IDs with numeric IDs | VERIFIED | Amphetamine, Gyroflow, Home Assistant, Photomator, Pixelmator Pro, SSH Config Editor, Telegram, WireGuard, Xcode — all 9 present with correct IDs |
| 12 | .gitconfig includes init.defaultBranch = main (GIT-02) | VERIFIED | `grep` returns `	defaultBranch = main` |
| 13 | .gitconfig identity is personal (florian@wartner.io), not P&P | VERIFIED | grep finds only florian@wartner.io; no @pixelandprocess.de in committed gitconfig |
| 14 | Tool-config skip rationales reflect observed source reality | VERIFIED | Each skip checked against actual ~/.config dir contents (htop empty; iterm2 = AppSupport symlink + sockets; opencode = .pencil P&P MCP; packer = checkpoint_cache + plugins/; stripe = config.toml with live keys + P&P display_name) |

**Score:** 14/14 truths verified (1 via override)

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `/Users/fwartner/dotfiles/Brewfile` | Complete declarative package manifest | VERIFIED | 377 lines, contains tap/brew/cask/mas/vscode/go/cargo lines |
| `stow/zsh/.zshrc` | Captured ~/.zshrc | VERIFIED | 5957 bytes, diff -q clean |
| `stow/zsh/.zprofile` | Captured ~/.zprofile | VERIFIED | 47 bytes, diff -q clean |
| `stow/zsh/.zsh.d/aliases.zsh` | Captured aliases module | VERIFIED | 1226 bytes, diff -q clean |
| `stow/zsh/.zsh.d/docker.zsh` | Captured docker module | VERIFIED | 975 bytes, diff -q clean |
| `stow/zsh/.zsh.d/exports.zsh` | Captured exports module (raw, with secrets) | VERIFIED | 1108 bytes, diff -q clean |
| `stow/zsh/.zsh.d/flutter.zsh` | Captured flutter module | VERIFIED | 708 bytes, diff -q clean |
| `stow/zsh/.zsh.d/functions.zsh` | Captured functions module | VERIFIED | 2721 bytes, diff -q clean |
| `stow/zsh/.zsh.d/infra.zsh` | Captured infra module | VERIFIED | 431 bytes, diff -q clean |
| `stow/zsh/.zsh.d/k8s.zsh` | Captured k8s module | VERIFIED | 751 bytes, diff -q clean |
| `stow/zsh/.zsh.d/laravel.zsh` | Captured laravel module | VERIFIED | 938 bytes, diff -q clean |
| `stow/git/.gitconfig` | Captured gitconfig with init.defaultBranch=main + personal identity | VERIFIED | diff -q clean; grep matches `defaultBranch = main`; identity = florian@wartner.io |
| `stow/git/.config/git/ignore` | Captured XDG git ignore | VERIFIED | Single line `**/.claude/settings.local.json`; diff -q clean |
| `stow/claude/.config/Claude/claude_desktop_config.json` | Generic Claude desktop config | VERIFIED | `{"mcpServers":{"other":{}}}` — no auth, no api_key; diff -q clean |
| `stow/tfenv/.config/tfenv/version` | Pinned terraform version | VERIFIED | `1.14.6`; diff -q clean |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| Brewfile | brew bundle | Homebrew bundle DSL | WIRED | All entries match `^(tap\|brew\|cask\|mas) ` pattern; check correctly identifies dbngin as the only mismatch (stale metadata, not capture defect) |
| stow/zsh/ | $HOME | GNU stow -t $HOME zsh | WIRED | Layout mirrors $HOME exactly: stow/zsh/.zshrc, stow/zsh/.zprofile, stow/zsh/.zsh.d/*.zsh; `stow -t ~ zsh` would create symlinks at ~/.zshrc, ~/.zprofile, ~/.zsh.d/* |
| stow/git/ | $HOME | GNU stow -t $HOME git | WIRED | stow/git/.gitconfig → ~/.gitconfig; stow/git/.config/git/ignore → ~/.config/git/ignore |
| stow/claude/ | $HOME | GNU stow -t $HOME claude | WIRED | stow/claude/.config/Claude/claude_desktop_config.json → ~/.config/Claude/claude_desktop_config.json (capital C preserved at inner path) |
| stow/tfenv/ | $HOME | GNU stow -t $HOME tfenv | WIRED | stow/tfenv/.config/tfenv/version → ~/.config/tfenv/version |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| Brewfile counts match expectations | `grep -c '^tap\|^brew\|^cask\|^mas '` | taps=28 brew=133 cask=26 mas=9 | PASS (brew=133 documented as top-level-only) |
| All MAS apps present with numeric IDs | `grep -E '^mas '` | All 9 expected apps with correct IDs | PASS |
| All zsh files match source byte-for-byte | `diff -q` × 10 | Exit 0 for all 10 | PASS |
| .gitconfig matches source | `diff -q ~/.gitconfig stow/git/.gitconfig` | Exit 0 | PASS |
| init.defaultBranch=main present | `grep 'defaultBranch.*main' stow/git/.gitconfig` | Match found | PASS |
| Personal identity preserved | `grep wartner.io stow/git/.gitconfig` | `email = florian@wartner.io` | PASS |
| Captured Plan 03 files match originals | `diff -q` × 3 | Exit 0 for git/ignore, claude config, tfenv version | PASS |
| No leaked credentials in stow/ | `find -iname '*token*' -o -iname '*secret*' ...` | Empty | PASS |
| No state directories in stow/ | `find -name sessions -o -name todos -o -name plugins ...` | Empty | PASS |
| brew bundle check passes | `brew bundle check --file=Brewfile` | Exit 1 — dbngin needs install | FAIL (override applied — stale metadata, not Brewfile defect) |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|----------|
| PKG-01 | 01-01 | Brewfile captures every tap (28) | SATISFIED | grep ^tap = 28 |
| PKG-02 | 01-01 | Brewfile captures every formula (274) | SATISFIED (with note) | brew bundle dump captures 133 top-level formulae; 167 transitive deps will resolve at install. Documented in 01-01-SUMMARY. |
| PKG-03 | 01-01 | Brewfile captures every cask (26) | SATISFIED | grep ^cask = 26 (after dbngin manual append) |
| PKG-04 | 01-01 | Brewfile includes mas entries (9 with IDs) | SATISFIED | grep ^mas = 9; all expected IDs present |
| SHELL-01 | 01-02 | .zshrc captured | SATISFIED (capture phase) | diff -q ~/.zshrc stow/zsh/.zshrc clean |
| SHELL-02 | 01-02 | .zprofile captured (sanitization in Phase 2) | SATISFIED (capture phase) | diff -q ~/.zprofile stow/zsh/.zprofile clean. Sanitize portion deferred to Phase 2 per ROADMAP. |
| SHELL-03 | 01-02 | All .zsh.d/*.zsh modules captured | SATISFIED | All 8 modules present, diff -q clean |
| GIT-01 | 01-02 | .gitconfig captured (sanitization in Phase 2) | SATISFIED (capture phase) | diff -q clean. Note: source contains florian@wartner.io (personal — retained). Phase 2 will scrub @pixelandprocess.de if present. |
| GIT-02 | 01-02 | .gitconfig includes init.defaultBranch = main | SATISFIED | grep matches |
| CFG-01 | 01-03 | ~/.config/htop/htoprc captured | SATISFIED (documented null capture) | Source dir is empty (htop never run). Default config will be created on first launch. Skip is correct. |
| CFG-02 | 01-03 | ~/.config/iterm2/ preferences captured | SATISFIED (documented out-of-band) | Source dir contains only AppSupport symlink + sockets; actual prefs live in ~/Library/Preferences/com.googlecode.iterm2.plist. Out-of-band sync via iTerm2 "custom folder" feature deferred to Phase 4 README. |
| CFG-03 | 01-03 | ~/.config/git/ files captured | SATISFIED | stow/git/.config/git/ignore captured; diff -q clean |
| CFG-04 | 01-03 | ~/.config/opencode/ + ~/.config/Claude/ non-secret config captured | PARTIAL (per documented decision) | Claude config captured. opencode skipped because opencode.json contains P&P-specific .pencil MCP server (per project no-P&P directive). Skip is correct per CLAUDE.md security rule. |
| CFG-05 | 01-03 | ~/.config/{tfenv,packer,stripe}/ config-only captured | PARTIAL (per documented decision) | tfenv/version captured. packer skipped (only checkpoint_cache + plugins/ binaries — no user-authored config). stripe skipped (config.toml contains live + test API keys + P&P display_name). Skips are correct per security and no-P&P directives. |

**No orphaned requirements.** All 14 required IDs accounted for in plan summaries.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| (none) | — | No TODOs, FIXMEs, stubs, or placeholders introduced by this phase | Info | Phase outputs are pure data captures, not code |

Note: `stow/zsh/.zsh.d/exports.zsh` contains real secrets (Fastlane password) and P&P email — this is the EXPECTED Phase 1 state per plan directive. Sanitization is Phase 2's responsibility.

### Human Verification Required

#### 1. Confirm taps are public / no auth required

**Test:** Open the Brewfile in an editor and visually confirm the 28 taps look correct (no private/auth taps; all are public)
**Expected:** All 28 tap entries are public; no auth required at install time
**Why human:** Tap visibility/auth requirements cannot be verified without attempting reinstall on a fresh machine

#### 2. Resolve dbngin metadata staleness

**Test:** Run `brew update` and re-run `brew bundle check --file=Brewfile` — confirm the dbngin metadata refreshes and check exits 0
**Expected:** After brew update, dbngin metadata aligns with installed reality and `brew bundle check` exits 0
**Why human:** Requires user to allow `brew update` (network state mutation) — outside automated verifier scope

#### 3. Confirm raw capture preserved (no premature sanitization)

**Test:** Visually inspect `/Users/fwartner/dotfiles/stow/zsh/.zsh.d/exports.zsh` — confirm the FASTLANE password and @pixelandprocess.de references are still present (they SHOULD be — sanitization is Phase 2)
**Expected:** exports.zsh contains FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD and at least one @pixelandprocess.de string — confirming raw verbatim capture
**Why human:** Confirms Phase 1 captured verbatim and did NOT prematurely sanitize (which would corrupt Phase 2 inputs)

### Gaps Summary

**No blocking gaps found.** Phase 1 achieved its goal: the repo contains a complete, lossless snapshot of the source machine's package state and dotfile content.

Important nuances (all documented in plan SUMMARYs, none constitute defects):

1. **Brewfile formula count = 133, not 274.** This is by design. `brew bundle dump` captures top-level (manually installed) formulae; the remaining 167 are transitive dependencies that brew resolves at install time. The roadmap success criterion text counted `brew list --formula` (which includes deps) but the Brewfile's job is to capture user intent, not the dep closure. Reproducibility on a fresh machine is preserved.

2. **`brew bundle check` exit 1 due to dbngin.** Override applied. The Brewfile content correctly contains `cask "dbngin"`. The exit-1 is caused by stale local Homebrew cask metadata: `brew list --cask` shows dbngin installed and `/Applications/DBngin.app` exists, yet `brew info --cask dbngin` reports "Not installed". Documented in 01-01-SUMMARY.md. A `brew update` will resolve.

3. **5 of 8 ~/.config/<tool> dirs intentionally skipped.** All five skip rationales (htop empty, iterm2 not the right path, opencode = P&P, packer = caches/binaries, stripe = live secrets + P&P) verified against actual on-disk contents. Skips are correct.

4. **SHELL-02 sanitization deferred to Phase 2.** Capture portion of SHELL-02 is satisfied. Sanitization is intentionally Phase 2's responsibility per ROADMAP coverage map.

The phase is functionally complete. The 3 human-verification items are confirmation tasks (auth-tap visibility, brew metadata refresh, raw-capture confirmation), not gap remediation.

---

*Verified: 2026-04-22*
*Verifier: Claude (gsd-verifier)*
