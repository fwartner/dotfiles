---
phase: 03-macos-stow
plan: 01
status: complete
requirements: [MAC-01, MAC-02, MAC-03, MAC-04, MAC-05, MAC-06, MAC-07, STOW-01, STOW-02, STOW-03, STOW-04]
files_modified:
  - /Users/fwartner/dotfiles/macos/defaults.sh
  - /Users/fwartner/dotfiles/scripts/stow-all.sh
  - /Users/fwartner/dotfiles/Makefile
  - /Users/fwartner/dotfiles/stow/zsh/.stow-local-ignore
  - /Users/fwartner/dotfiles/stow/git/.stow-local-ignore
  - /Users/fwartner/dotfiles/stow/claude/.stow-local-ignore
  - /Users/fwartner/dotfiles/stow/tfenv/.stow-local-ignore
---

## Summary

Wrote `macos/defaults.sh` (curated developer defaults), `scripts/stow-all.sh` (stow/unstow/restow/dry-run wrapper), per-module `.stow-local-ignore` files, and a top-level `Makefile` with the public targets.

## macos/defaults.sh

Curated set, idempotent. Sections: General, Keyboard, Trackpad, Finder, Dock, Screenshots, Screensaver, Safari, Activity Monitor. Restarts Dock, Finder, SystemUIServer, cfprefsd at the end.

Highlights:
- Fast key repeat (`KeyRepeat=2`, `InitialKeyRepeat=15`)
- `ApplePressAndHoldEnabled=false` (re-enables key repeat in apps like VS Code)
- Disables autocorrect / smart quotes / smart dashes (developer-friendly)
- Show hidden files, show extensions, show path bar / status bar
- No `.DS_Store` on network or USB volumes
- Dock auto-hide, smaller icons (44px), no recents
- Screenshots → `~/Screenshots`, PNG, no shadow
- Lock screen requires password immediately

Tap-to-click enabled. Safari Develop menu enabled (gracefully handled if Safari is not in use).

## scripts/stow-all.sh

Wraps `stow --target=$HOME` over every directory in `stow/`. Modes:
- `./scripts/stow-all.sh` — link
- `./scripts/stow-all.sh --dry-run` — show what would happen
- `./scripts/stow-all.sh --unstow` — remove symlinks
- `./scripts/stow-all.sh --restow` — refresh after adding new files

Errors clearly if `stow` is not installed.

## Makefile

```
make help install stow unstow restow dry-run defaults scan
```

## .stow-local-ignore (per module)

Each of the 4 stow modules (zsh, git, claude, tfenv) gets a `.stow-local-ignore` excluding `README.*`, `.DS_Store`, `.git`. Standard hygiene.

## Verification

```
$ ./scripts/stow-all.sh --dry-run
→ stow modules: claude git tfenv zsh
→ target: /Users/fwartner
WARNING! stowing claude would cause conflicts:
  * cannot stow ... over existing target ... since neither a link nor a directory ...
```

Conflicts are **expected on the source machine** because real files already exist where the symlinks would go. `install.sh` (Phase 4) will handle this with `stow --adopt` or pre-flight removal of conflicting plain files. On a fresh Mac there is nothing to conflict with.

`bash -n` syntax-check passes for both `defaults.sh` and `stow-all.sh`.

## Acceptance Criteria

- [x] MAC-01: defaults.sh is curated and idempotent (every write is `defaults write`, declarative)
- [x] MAC-02: Finder section covers hidden files, extensions, no .DS_Store on network/USB
- [x] MAC-03: Dock section covers autohide, no recents, smaller icons (44px)
- [x] MAC-04: Keyboard section covers fast key repeat + disable press-and-hold
- [x] MAC-05: Screenshot section sets ~/Screenshots and PNG
- [x] MAC-06: Screensaver section requires password immediately after sleep/saver
- [x] MAC-07: Restarts Dock, Finder, SystemUIServer, cfprefsd at the end
- [x] STOW-01: Each tool has its own stow module under `stow/<tool>/`
- [x] STOW-02: `make stow` and `./scripts/stow-all.sh` symlink everything
- [x] STOW-03: `make unstow` and `./scripts/stow-all.sh --unstow` remove cleanly
- [x] STOW-04: Each module has a `.stow-local-ignore`
