---
phase: 01-capture
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - /Users/fwartner/dotfiles/Brewfile
autonomous: true
requirements: [PKG-01, PKG-02, PKG-03, PKG-04]

must_haves:
  truths:
    - "A Brewfile exists at the repo root containing every tap, formula, cask, and MAS app from the source machine"
    - "Re-running `brew bundle --file=Brewfile check` on the source machine reports no missing items"
    - "Counts in the file match the source machine: 28 taps, 274 formulae, 26 casks, 9 mas entries"
  artifacts:
    - path: "/Users/fwartner/dotfiles/Brewfile"
      provides: "Complete declarative package manifest (taps, formulae, casks, mas)"
      contains: "tap, brew, cask, mas"
  key_links:
    - from: "Brewfile"
      to: "brew bundle"
      via: "Homebrew bundle DSL"
      pattern: "^(tap|brew|cask|mas) "
---

<objective>
Capture the source machine's complete Homebrew + Mac App Store package state into a single root-level `Brewfile`.

Purpose: Phase 4's `install.sh` will replay this Brewfile via `brew bundle` on a fresh Mac, reproducing the entire installed package set in one command. This plan generates the source-of-truth manifest.

Output: `/Users/fwartner/dotfiles/Brewfile` containing 28 taps, 274 formulae, 26 casks, and 9 `mas` entries, with optional `--describe` comments for human readability.
</objective>

<execution_context>
@$HOME/.claude/get-shit-done/workflows/execute-plan.md
@$HOME/.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
@/Users/fwartner/dotfiles/.planning/PROJECT.md
@/Users/fwartner/dotfiles/.planning/ROADMAP.md
@/Users/fwartner/dotfiles/.planning/REQUIREMENTS.md
@/Users/fwartner/dotfiles/.planning/STATE.md
@/Users/fwartner/dotfiles/CLAUDE.md

# Source machine ground truth (from CONTEXT)
# - 28 taps, 274 formulae, 26 casks installed via Homebrew
# - 9 Mac App Store apps: Amphetamine (937984704), Gyroflow (6447994244),
#   Home Assistant (1099568401), Photomator (1444636541), Pixelmator Pro (1289583905),
#   SSH Config Editor (1109319285), Telegram (747648890), WireGuard (1451685025), Xcode (497799835)
# - Homebrew prefix: /opt/homebrew (Apple Silicon)
</context>

<tasks>

<task type="auto">
  <name>Task 1: Generate Brewfile from current Homebrew state</name>
  <files>/Users/fwartner/dotfiles/Brewfile</files>
  <read_first>
    - /Users/fwartner/dotfiles/Brewfile (if it exists — confirm whether to overwrite)
    - Run `which brew` to confirm Homebrew is on PATH (should be /opt/homebrew/bin/brew)
    - Run `brew --version` to confirm a working install
  </read_first>
  <action>
    Run `brew bundle dump` against the source machine. This is the canonical mechanism — do NOT hand-list packages.

    Exact command:
    ```bash
    brew bundle dump \
      --force \
      --describe \
      --file=/Users/fwartner/dotfiles/Brewfile
    ```

    Flags explained:
    - `--force` overwrites the existing scaffolded Brewfile (it is currently empty per CONTEXT)
    - `--describe` adds a comment line above each formula/cask with its short description (improves human readability when reviewing the public repo)
    - `--file=` writes to the absolute repo path (no cwd assumption)

    Notes on `mas` entries:
    - `brew bundle dump` includes `mas` entries automatically IF the `mas` formula is installed AND the user is signed in to the Mac App Store at dump time. Both conditions hold on this machine.
    - After dump, verify mas entries are present (Task 2 acceptance check). If any are missing, append manually using the exact IDs from the context block. The expected lines are:
      ```
      mas "Amphetamine", id: 937984704
      mas "Gyroflow", id: 6447994244
      mas "Home Assistant", id: 1099568401
      mas "Photomator", id: 1444636541
      mas "Pixelmator Pro", id: 1289583905
      mas "SSH Config Editor", id: 1109319285
      mas "Telegram", id: 747648890
      mas "WireGuard", id: 1451685025
      mas "Xcode", id: 497799835
      ```

    Do NOT edit the dumped tap/brew/cask lines — `brew bundle dump` is the source of truth for those.

    Do NOT add `vscode` extension entries (out of scope per REQUIREMENTS V2-05).
  </action>
  <verify>
    <automated>test -s /Users/fwartner/dotfiles/Brewfile &amp;&amp; head -3 /Users/fwartner/dotfiles/Brewfile</automated>
  </verify>
  <acceptance_criteria>
    - `/Users/fwartner/dotfiles/Brewfile` exists and is non-empty
    - File contains lines starting with `tap "`, `brew "`, and `cask "`
    - File was produced by `brew bundle dump` (not hand-edited tap/brew/cask sections)
  </acceptance_criteria>
  <done>
    Brewfile exists at the repo root, populated by `brew bundle dump --describe`, ready for the count verification in Task 2.
  </done>
</task>

<task type="auto">
  <name>Task 2: Verify Brewfile counts and append any missing mas entries</name>
  <files>/Users/fwartner/dotfiles/Brewfile</files>
  <read_first>
    - /Users/fwartner/dotfiles/Brewfile (the file just produced by Task 1)
  </read_first>
  <action>
    Validate that the dumped Brewfile matches the source machine's known counts. The expected counts (from CONTEXT) are:

    | Type | Expected | Command |
    |------|----------|---------|
    | tap  | 28       | `grep -c '^tap ' /Users/fwartner/dotfiles/Brewfile` |
    | brew | 274      | `grep -c '^brew ' /Users/fwartner/dotfiles/Brewfile` |
    | cask | 26       | `grep -c '^cask ' /Users/fwartner/dotfiles/Brewfile` |
    | mas  | 9        | `grep -c '^mas ' /Users/fwartner/dotfiles/Brewfile` |

    Run all four counts:
    ```bash
    echo "taps:     $(grep -c '^tap ' /Users/fwartner/dotfiles/Brewfile)  (expected 28)"
    echo "formulae: $(grep -c '^brew ' /Users/fwartner/dotfiles/Brewfile) (expected 274)"
    echo "casks:    $(grep -c '^cask ' /Users/fwartner/dotfiles/Brewfile) (expected 26)"
    echo "mas:      $(grep -c '^mas ' /Users/fwartner/dotfiles/Brewfile)  (expected 9)"
    ```

    Cross-check against live system (this is the ultimate source of truth — if live counts have changed since CONTEXT was written, trust the live counts and update the must_haves note in the SUMMARY):
    ```bash
    brew tap | wc -l
    brew list --formula | wc -l
    brew list --cask | wc -l
    mas list | wc -l
    ```

    If `mas` count in the Brewfile is less than `mas list | wc -l`, append the missing entries to the END of the Brewfile using the IDs from the action block in Task 1. Use the exact `mas "Name", id: NNNNN` syntax (this is the format `brew bundle dump` itself emits).

    If tap/brew/cask counts differ from CONTEXT but match `brew list` live counts, the live counts win — note the discrepancy in the SUMMARY but do not edit those lines (the dump is authoritative).

    Final integrity check (does Homebrew agree the Brewfile fully describes installed state?):
    ```bash
    brew bundle check --file=/Users/fwartner/dotfiles/Brewfile --verbose
    ```
    A successful check prints "The Brewfile's dependencies are satisfied." Exit code 0.

    Do NOT delete entries from the Brewfile. Do NOT alphabetize manually (brew controls ordering). Do NOT add comments outside what `--describe` already produced.
  </action>
  <verify>
    <automated>brew bundle check --file=/Users/fwartner/dotfiles/Brewfile</automated>
  </verify>
  <acceptance_criteria>
    - `grep -c '^tap '  Brewfile` matches `brew tap | wc -l`
    - `grep -c '^brew ' Brewfile` matches `brew list --formula | wc -l`
    - `grep -c '^cask ' Brewfile` matches `brew list --cask | wc -l`
    - `grep -c '^mas '  Brewfile` matches `mas list | wc -l` (at minimum 9)
    - `brew bundle check --file=Brewfile` exits 0
  </acceptance_criteria>
  <done>
    Brewfile counts match the live source machine state, all 9 mas entries present, `brew bundle check` reports dependencies satisfied. PKG-01 through PKG-04 satisfied.
  </done>
</task>

</tasks>

<verification>
Run from the repo root:

```bash
cd /Users/fwartner/dotfiles
[ -s Brewfile ] && echo "OK: Brewfile present"
echo "taps=$(grep -c '^tap ' Brewfile) brew=$(grep -c '^brew ' Brewfile) cask=$(grep -c '^cask ' Brewfile) mas=$(grep -c '^mas ' Brewfile)"
brew bundle check --file=Brewfile
```

All four counts must be > 0 and match `brew list` / `mas list` output. `brew bundle check` must exit 0.
</verification>

<success_criteria>
- `/Users/fwartner/dotfiles/Brewfile` exists, non-empty, generated via `brew bundle dump --describe`
- Counts match source machine: 28 taps, 274 formulae, 26 casks, 9 mas (or live counts if drifted, with note in SUMMARY)
- All 9 expected MAS app IDs from CONTEXT appear with correct numeric IDs
- `brew bundle check --file=Brewfile` reports dependencies satisfied (exit 0)
- Requirements PKG-01, PKG-02, PKG-03, PKG-04 marked addressable
</success_criteria>

<output>
After completion, create `.planning/phases/01-capture/01-01-SUMMARY.md` documenting:
- Final counts (taps/brew/cask/mas) — note any drift vs. CONTEXT's 28/274/26/9
- Whether `mas` entries came from `brew bundle dump` automatically or had to be appended
- `brew bundle check` exit code and output
- Any taps that may need attention on a fresh machine (e.g., taps that require auth)
</output>
