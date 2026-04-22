---
phase: 01-capture
plan: 03
status: complete
requirements: [CFG-01, CFG-02, CFG-03, CFG-04, CFG-05]
files_modified:
  - /Users/fwartner/dotfiles/stow/git/.config/git/ignore
  - /Users/fwartner/dotfiles/stow/claude/.config/Claude/claude_desktop_config.json
  - /Users/fwartner/dotfiles/stow/tfenv/.config/tfenv/version
---

## Summary

Inspected all 8 candidate `~/.config/<tool>` directories. Most contained nothing worth versioning (empty, runtime caches, downloaded binaries, machine-specific symlinks, or P&P-specific configuration). Captured the 3 small, generic, safe files.

## Per-Tool Decisions

| Tool | Decision | Rationale |
|------|----------|-----------|
| `~/.config/htop` | **Skip** — empty | htop has not been run yet; no `htoprc` generated. The default config will be created on first launch on the new machine. |
| `~/.config/iterm2` | **Skip** — symlink + sockets only | The actual iTerm2 prefs live in `~/Library/Preferences/com.googlecode.iterm2.plist` (binary, 19KB, machine-specific UUIDs). Recommended approach is iTerm2's "Load preferences from custom folder" feature — to be documented in README. |
| `~/.config/git/ignore` | **Capture** | One-line global gitignore (`**/.claude/settings.local.json`). Generic, safe. → `stow/git/.config/git/ignore` |
| `~/.config/git/.gitconfig` | (already captured by Plan 02) | — |
| `~/.config/opencode/opencode.json` | **Skip** — P&P content | Configures the `.pencil` MCP server, which is P&P-specific tooling. Per the project directive (no P&P content), skipped entirely. |
| `~/.config/Claude/claude_desktop_config.json` | **Capture** | Generic empty `mcpServers` shell (`{"mcpServers":{"other":{}}}`). Safe. → `stow/claude/.config/Claude/claude_desktop_config.json` |
| `~/.config/tfenv/version` | **Capture** | Pinned terraform version (`1.14.6`). Useful as a baseline. → `stow/tfenv/.config/tfenv/version` |
| `~/.config/tfenv/versions/` | **Skip** — binaries | Downloaded terraform binaries (~80MB each). Will be re-downloaded by `tfenv install` on the new machine. |
| `~/.config/packer/` | **Skip** — caches and binaries | Only contains `checkpoint_cache`, `checkpoint_signature` (runtime), and `plugins/` (downloaded binaries). Nothing user-authored. |
| `~/.config/stripe/config.toml` | **Skip** — secrets + P&P | Contains live and test Stripe API keys plus `display_name = 'Pixel & Process UG (haftungsbeschränkt)'`. Excluded for both PUB and P&P reasons. |

## Notes

- The original plan suggested capturing 8 stow modules (`stow/{htop,iterm2,git,opencode,claude,tfenv,packer,stripe}/`). Reality is 3 modules (`stow/git/`, `stow/claude/`, `stow/tfenv/`). The lower count is correct — there is genuinely nothing to capture from the other 5.
- `stow/git/` now contains both `.gitconfig` (Plan 02) and `.config/git/ignore` (this plan). The directory structure is correct: stowing `stow/git/` symlinks both `~/.gitconfig` and `~/.config/git/ignore` into place.
- iTerm2 prefs strategy will be documented in Phase 4's README.

## Acceptance Criteria

- [x] CFG-01 (htop): documented decision (no file to capture)
- [x] CFG-02 (iterm2): documented decision (out-of-band sync via iTerm2's custom folder feature)
- [x] CFG-03 (git): `~/.config/git/ignore` captured into `stow/git/`
- [x] CFG-04 (opencode + Claude): Claude config captured; opencode skipped with reason (P&P)
- [x] CFG-05 (tfenv + packer + stripe): tfenv `version` captured; packer skipped (caches only); stripe skipped (P&P + live keys)
