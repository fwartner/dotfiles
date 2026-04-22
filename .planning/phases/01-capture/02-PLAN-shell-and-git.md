---
phase: 01-capture
plan: 02
type: execute
wave: 1
depends_on: []
files_modified:
  - /Users/fwartner/dotfiles/stow/zsh/.zshrc
  - /Users/fwartner/dotfiles/stow/zsh/.zprofile
  - /Users/fwartner/dotfiles/stow/zsh/.zsh.d/aliases.zsh
  - /Users/fwartner/dotfiles/stow/zsh/.zsh.d/docker.zsh
  - /Users/fwartner/dotfiles/stow/zsh/.zsh.d/exports.zsh
  - /Users/fwartner/dotfiles/stow/zsh/.zsh.d/flutter.zsh
  - /Users/fwartner/dotfiles/stow/zsh/.zsh.d/functions.zsh
  - /Users/fwartner/dotfiles/stow/zsh/.zsh.d/infra.zsh
  - /Users/fwartner/dotfiles/stow/zsh/.zsh.d/k8s.zsh
  - /Users/fwartner/dotfiles/stow/zsh/.zsh.d/laravel.zsh
  - /Users/fwartner/dotfiles/stow/git/.gitconfig
autonomous: true
requirements: [SHELL-01, SHELL-02, SHELL-03, GIT-01, GIT-02]

must_haves:
  truths:
    - "Every shell file at $HOME (~/.zshrc, ~/.zprofile, ~/.zsh.d/*.zsh) has a byte-identical copy in stow/zsh/"
    - "~/.gitconfig has a byte-identical copy in stow/git/"
    - "All copies are RAW (sanitization is Phase 2's job — secrets and P&P refs may still appear)"
    - "The stow/zsh and stow/git module directories mirror $HOME layout exactly so `stow -t ~ zsh` and `stow -t ~ git` will recreate the original symlinks"
  artifacts:
    - path: "/Users/fwartner/dotfiles/stow/zsh/.zshrc"
      provides: "Captured ~/.zshrc"
    - path: "/Users/fwartner/dotfiles/stow/zsh/.zprofile"
      provides: "Captured ~/.zprofile"
    - path: "/Users/fwartner/dotfiles/stow/zsh/.zsh.d/aliases.zsh"
      provides: "Captured ~/.zsh.d/aliases.zsh"
    - path: "/Users/fwartner/dotfiles/stow/zsh/.zsh.d/docker.zsh"
      provides: "Captured ~/.zsh.d/docker.zsh"
    - path: "/Users/fwartner/dotfiles/stow/zsh/.zsh.d/exports.zsh"
      provides: "Captured ~/.zsh.d/exports.zsh"
    - path: "/Users/fwartner/dotfiles/stow/zsh/.zsh.d/flutter.zsh"
      provides: "Captured ~/.zsh.d/flutter.zsh"
    - path: "/Users/fwartner/dotfiles/stow/zsh/.zsh.d/functions.zsh"
      provides: "Captured ~/.zsh.d/functions.zsh"
    - path: "/Users/fwartner/dotfiles/stow/zsh/.zsh.d/infra.zsh"
      provides: "Captured ~/.zsh.d/infra.zsh"
    - path: "/Users/fwartner/dotfiles/stow/zsh/.zsh.d/k8s.zsh"
      provides: "Captured ~/.zsh.d/k8s.zsh"
    - path: "/Users/fwartner/dotfiles/stow/zsh/.zsh.d/laravel.zsh"
      provides: "Captured ~/.zsh.d/laravel.zsh"
    - path: "/Users/fwartner/dotfiles/stow/git/.gitconfig"
      provides: "Captured ~/.gitconfig with init.defaultBranch = main and personal identity (florian@wartner.io)"
  key_links:
    - from: "stow/zsh/"
      to: "$HOME"
      via: "GNU stow -t $HOME zsh"
      pattern: "stow.*zsh"
    - from: "stow/git/"
      to: "$HOME"
      via: "GNU stow -t $HOME git"
      pattern: "stow.*git"
---

<objective>
Capture the source machine's shell configuration (zsh top-level files plus the modular `~/.zsh.d/*.zsh` modules) and `~/.gitconfig` into the stow module layout, byte-identical to the originals.

Purpose: These are the active shell + git settings of the source machine. Phase 2 will sanitize them (strip Fastlane password, swap @pixelandprocess.de email out, externalize secrets). Phase 3 will wire them through GNU stow. This plan only captures raw source.

Output: `stow/zsh/` and `stow/git/` directories containing exact copies of every file listed in `files_modified`, ready for sanitization in Phase 2.

Critical: Sanitization is OUT OF SCOPE for this plan. Copy verbatim. Do NOT redact, edit, or normalize. The Fastlane password and `@pixelandprocess.de` references MAY appear in the captured files at this point — that is intentional and expected.
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

# Source files (verbatim — sanitization is Phase 2):
# - ~/.zshrc
# - ~/.zprofile
# - ~/.zsh.d/{aliases,docker,exports,flutter,functions,infra,k8s,laravel}.zsh
# - ~/.gitconfig (Florian Wartner / florian@wartner.io / init.defaultBranch=main — KEEP wartner.io, that is personal not P&P)

# Stow layout convention: stow/<module>/<path-relative-to-$HOME>
# So ~/.zshrc -> stow/zsh/.zshrc, and ~/.zsh.d/exports.zsh -> stow/zsh/.zsh.d/exports.zsh
# `cd stow && stow -t ~ zsh` will create the matching symlinks in $HOME.
</context>

<tasks>

<task type="auto">
  <name>Task 1: Capture zsh files into stow/zsh/</name>
  <files>
    /Users/fwartner/dotfiles/stow/zsh/.zshrc,
    /Users/fwartner/dotfiles/stow/zsh/.zprofile,
    /Users/fwartner/dotfiles/stow/zsh/.zsh.d/aliases.zsh,
    /Users/fwartner/dotfiles/stow/zsh/.zsh.d/docker.zsh,
    /Users/fwartner/dotfiles/stow/zsh/.zsh.d/exports.zsh,
    /Users/fwartner/dotfiles/stow/zsh/.zsh.d/flutter.zsh,
    /Users/fwartner/dotfiles/stow/zsh/.zsh.d/functions.zsh,
    /Users/fwartner/dotfiles/stow/zsh/.zsh.d/infra.zsh,
    /Users/fwartner/dotfiles/stow/zsh/.zsh.d/k8s.zsh,
    /Users/fwartner/dotfiles/stow/zsh/.zsh.d/laravel.zsh
  </files>
  <read_first>
    - Run `ls -la ~/.zshrc ~/.zprofile` to confirm both top-level files exist as regular files (not already symlinks into the repo)
    - Run `ls -la ~/.zsh.d/` to confirm all 8 expected modules exist
    - Run `ls -la /Users/fwartner/dotfiles/stow/zsh/ 2>/dev/null` to see if the target directory has any pre-existing content that would be overwritten
  </read_first>
  <action>
    Create the target directory tree, then copy each file individually with `cp -p` (preserves mtime/perms — useful for later diff checks).

    Step 1 — create destination dirs:
    ```bash
    mkdir -p /Users/fwartner/dotfiles/stow/zsh/.zsh.d
    ```

    Step 2 — copy top-level files:
    ```bash
    cp -p ~/.zshrc    /Users/fwartner/dotfiles/stow/zsh/.zshrc
    cp -p ~/.zprofile /Users/fwartner/dotfiles/stow/zsh/.zprofile
    ```

    Step 3 — copy every module (explicit list, no globs that could miss anything):
    ```bash
    for mod in aliases docker exports flutter functions infra k8s laravel; do
      cp -p ~/.zsh.d/${mod}.zsh /Users/fwartner/dotfiles/stow/zsh/.zsh.d/${mod}.zsh
    done
    ```

    IMPORTANT — DO NOT:
    - Run `sed`, `awk`, or any in-place edits on the copies
    - Strip the Fastlane application-specific password
    - Remove `@pixelandprocess.de` references
    - Reformat indentation, line endings, or comments
    - Skip files because "they look like they have secrets" — capture is verbatim, sanitization is Phase 2

    If any source file is already a symlink (e.g., `~/.zshrc -> /Users/fwartner/dotfiles/stow/zsh/.zshrc`) the user has previously stowed something. STOP and report — do not silently overwrite via the symlink. The expected starting state is regular files at `$HOME`.
  </action>
  <verify>
    <automated>diff -q ~/.zshrc /Users/fwartner/dotfiles/stow/zsh/.zshrc &amp;&amp; diff -q ~/.zprofile /Users/fwartner/dotfiles/stow/zsh/.zprofile &amp;&amp; for m in aliases docker exports flutter functions infra k8s laravel; do diff -q ~/.zsh.d/${m}.zsh /Users/fwartner/dotfiles/stow/zsh/.zsh.d/${m}.zsh; done</automated>
  </verify>
  <acceptance_criteria>
    - `/Users/fwartner/dotfiles/stow/zsh/.zshrc` exists and `diff -q ~/.zshrc stow/zsh/.zshrc` shows no differences
    - `/Users/fwartner/dotfiles/stow/zsh/.zprofile` exists and `diff -q` shows no differences
    - All 8 files at `/Users/fwartner/dotfiles/stow/zsh/.zsh.d/{aliases,docker,exports,flutter,functions,infra,k8s,laravel}.zsh` exist
    - `diff -q` against the corresponding `~/.zsh.d/*.zsh` source shows no differences for any of the 8 modules
    - `find /Users/fwartner/dotfiles/stow/zsh -type f | wc -l` returns 10 (2 top-level + 8 modules)
  </acceptance_criteria>
  <done>
    `stow/zsh/` is a complete byte-identical mirror of the zsh portion of `$HOME`, ready for sanitization. SHELL-01, SHELL-02, SHELL-03 satisfied at the capture level.
  </done>
</task>

<task type="auto">
  <name>Task 2: Capture .gitconfig into stow/git/</name>
  <files>/Users/fwartner/dotfiles/stow/git/.gitconfig</files>
  <read_first>
    - Run `ls -la ~/.gitconfig` to confirm it exists as a regular file
    - Run `git config --global --get user.email` and `git config --global --get user.name` to confirm what is currently committed (expected: name="Florian Wartner", email="florian@wartner.io")
    - Run `git config --global --get init.defaultBranch` to confirm `main` is set (required by GIT-02)
  </read_first>
  <action>
    Capture `~/.gitconfig` verbatim into the git stow module.

    Step 1 — create destination dir:
    ```bash
    mkdir -p /Users/fwartner/dotfiles/stow/git
    ```

    Step 2 — copy:
    ```bash
    cp -p ~/.gitconfig /Users/fwartner/dotfiles/stow/git/.gitconfig
    ```

    Note on identity (per CONTEXT):
    - Current values are `name = Florian Wartner` and `email = florian@wartner.io`
    - `florian@wartner.io` is the user's PERSONAL email — KEEP IT. Do NOT strip or replace.
    - Only `@pixelandprocess.de` is the company email that must be removed (Phase 2's job).
    - `init.defaultBranch = main` MUST appear in the captured file. If it does not appear in `~/.gitconfig`, this means `git config --global init.defaultBranch main` was never run on this machine. In that case, run it once:
      ```bash
      git config --global init.defaultBranch main
      ```
      then re-copy.

    DO NOT:
    - Edit the copied .gitconfig in any way
    - Add or remove sections, aliases, or includes
    - Replace the personal email
  </action>
  <verify>
    <automated>diff -q ~/.gitconfig /Users/fwartner/dotfiles/stow/git/.gitconfig &amp;&amp; grep -E '^\s*defaultBranch\s*=\s*main' /Users/fwartner/dotfiles/stow/git/.gitconfig</automated>
  </verify>
  <acceptance_criteria>
    - `/Users/fwartner/dotfiles/stow/git/.gitconfig` exists
    - `diff -q ~/.gitconfig /Users/fwartner/dotfiles/stow/git/.gitconfig` shows no differences (exit 0)
    - The captured file contains a line matching `defaultBranch = main` (GIT-02)
    - The captured file contains `florian@wartner.io` (personal identity preserved — GIT-01 is "generic non-P&P", and wartner.io is personal not P&P; final scrub of `@pixelandprocess.de` happens in Phase 2)
  </acceptance_criteria>
  <done>
    `stow/git/.gitconfig` is a byte-identical copy of `~/.gitconfig` containing `init.defaultBranch = main` and the user's personal identity. GIT-01 and GIT-02 satisfied at the capture level.
  </done>
</task>

</tasks>

<verification>
Run from the repo root:

```bash
cd /Users/fwartner/dotfiles

# Confirm the full stow/zsh tree mirrors $HOME
diff -q ~/.zshrc    stow/zsh/.zshrc
diff -q ~/.zprofile stow/zsh/.zprofile
for m in aliases docker exports flutter functions infra k8s laravel; do
  diff -q ~/.zsh.d/${m}.zsh stow/zsh/.zsh.d/${m}.zsh
done

# Confirm .gitconfig
diff -q ~/.gitconfig stow/git/.gitconfig
grep -E 'defaultBranch\s*=\s*main' stow/git/.gitconfig

# File count sanity
find stow/zsh -type f | wc -l   # expect 10
find stow/git -type f | wc -l   # expect 1
```

All `diff -q` calls must exit 0 with no output. Final `grep` must match a line.
</verification>

<success_criteria>
- All 11 files exist at the expected paths under `stow/zsh/` and `stow/git/`
- Every file is byte-identical to the corresponding source at `$HOME` (verified by `diff -q`)
- `init.defaultBranch = main` is present in the captured `.gitconfig` (GIT-02)
- No sanitization performed — Fastlane secrets and `@pixelandprocess.de` may still appear (this is correct for Phase 1)
- Requirements SHELL-01, SHELL-02, SHELL-03, GIT-01, GIT-02 marked addressable
</success_criteria>

<output>
After completion, create `.planning/phases/01-capture/01-02-SUMMARY.md` documenting:
- File-by-file diff results (all should be no-diff)
- Total bytes captured under `stow/zsh/` (e.g., `du -sh stow/zsh`)
- Confirmation that `init.defaultBranch = main` is present in `.gitconfig`
- Explicit note: "Capture is RAW. Phase 2 will strip Fastlane password and @pixelandprocess.de."
- Any source files that turned out to already be symlinks (anomaly worth flagging)
</output>
