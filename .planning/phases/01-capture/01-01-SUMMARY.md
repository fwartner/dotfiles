---
phase: 01-capture
plan: 01
status: complete
requirements: [PKG-01, PKG-02, PKG-03, PKG-04]
files_modified:
  - /Users/fwartner/dotfiles/Brewfile
---

## Summary

Generated `Brewfile` at the repo root via `brew bundle dump --force --describe --file=Brewfile`. All Mac App Store entries were included automatically by `brew bundle dump` since `mas` is installed and the user is signed in.

## Final Counts

| Type | Brewfile | Live (`brew list`) | Notes |
|------|----------|--------------------|-------|
| tap  | 28       | 28                 | Match |
| brew | 133      | 300                | Match — dump only includes top-level (manually installed) formulae; the other 167 are pulled-in dependencies that brew will resolve on install |
| cask | 26       | 26                 | After manually appending `dbngin` (see below) |
| mas  | 9        | 9                  | All present from automatic dump |

## Notes

- `brew bundle check --file=Brewfile` exits 0: "The Brewfile's dependencies are satisfied."
- `dbngin` was manually appended after the dump. `brew list --cask` includes it and `/Applications/DBngin.app` exists, but `brew info --cask dbngin` reports "Not installed" — stale Homebrew metadata. Without the manual append, a fresh machine would not get DBngin.
- Two casks are listed under their tap path (`hmans/beans/beans`, `bysiber/cleardisk/cleardisk`) — equivalent to the short names that appear in `brew list`.
- The `--describe` flag adds a comment line above each entry with the formula/cask short description, improving readability for the public repo.

## Taps Worth Flagging for Fresh-Machine Install

None require auth at install time. All 28 taps are public.

## Acceptance Criteria

- [x] Brewfile exists and is non-empty
- [x] Contains `tap "`, `brew "`, `cask "`, `mas "` lines
- [x] Counts match live machine state (with documented dependency-vs-top-level distinction)
- [x] All 9 expected MAS app IDs present
- [x] `brew bundle check` exits 0
- [x] PKG-01, PKG-02, PKG-03, PKG-04 satisfied
