---
phase: 01-capture
plan: 03
type: execute
wave: 1
depends_on: []
files_modified:
  - /Users/fwartner/dotfiles/stow/htop/.config/htop/
  - /Users/fwartner/dotfiles/stow/iterm2/.config/iterm2/
  - /Users/fwartner/dotfiles/stow/git/.config/git/
  - /Users/fwartner/dotfiles/stow/opencode/.config/opencode/
  - /Users/fwartner/dotfiles/stow/claude/.config/Claude/
  - /Users/fwartner/dotfiles/stow/tfenv/.config/tfenv/
  - /Users/fwartner/dotfiles/stow/packer/.config/packer/
  - /Users/fwartner/dotfiles/stow/stripe/.config/stripe/
autonomous: true
requirements: [CFG-01, CFG-02, CFG-03, CFG-04, CFG-05]

must_haves:
  truths:
    - "Each of htop, iterm2, git (under .config), opencode, Claude, tfenv, packer, stripe has its own stow module under stow/<tool>/.config/<tool>/"
    - "Every captured directory contains the tool's main config files but NO caches, sessions, tokens, or live credentials"
    - "Re-stowing each module via `stow -t ~ <tool>` would recreate the original ~/.config/<tool>/ layout for the captured (config-only) subset"
  artifacts:
    - path: "/Users/fwartner/dotfiles/stow/htop/.config/htop/htoprc"
      provides: "htop preferences"
    - path: "/Users/fwartner/dotfiles/stow/iterm2/.config/iterm2/"
      provides: "iTerm2 preferences (plist export and any related files)"
    - path: "/Users/fwartner/dotfiles/stow/git/.config/git/"
      provides: "Git ignore patterns and attributes (XDG path)"
    - path: "/Users/fwartner/dotfiles/stow/opencode/.config/opencode/"
      provides: "opencode CLI configuration (no auth)"
    - path: "/Users/fwartner/dotfiles/stow/claude/.config/Claude/"
      provides: "Claude desktop/CLI configuration (no sessions, no auth)"
    - path: "/Users/fwartner/dotfiles/stow/tfenv/.config/tfenv/"
      provides: "tfenv configuration"
    - path: "/Users/fwartner/dotfiles/stow/packer/.config/packer/"
      provides: "Packer configuration (no plugin binaries)"
    - path: "/Users/fwartner/dotfiles/stow/stripe/.config/stripe/"
      provides: "Stripe CLI configuration (no live credentials)"
  key_links:
    - from: "stow/<tool>/.config/<tool>/"
      to: "~/.config/<tool>/"
      via: "GNU stow -t $HOME <tool>"
      pattern: "stow.*<tool>"
---

<objective>
Capture the configuration-only contents of eight `~/.config/<tool>` directories into per-tool stow modules, explicitly excluding caches, session stores, tokens, plugin binaries, and live credentials.

Purpose: These tool configs make the developer environment feel like home (htop colors, iTerm2 keybinds, git ignores, Claude/opencode preferences, tfenv/packer/stripe defaults). Phase 3 wires them via stow; Phase 4's install script provisions them. This plan only captures the config-pure subset.

Output: Eight stow modules under `stow/{htop,iterm2,git,opencode,claude,tfenv,packer,stripe}/.config/<tool>/` containing the tool's main config files and nothing operational/sensitive.

Scope clarification:
- "Capture config, not state" is the prime directive
- Caches, sessions, tokens, OAuth state, history, plugin binaries → EXCLUDED
- Sanitization of remaining content (e.g., secrets accidentally in config files) → Phase 2's job; this plan only excludes structural noise/credentials
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

# Source-machine ~/.config tool dirs to capture (config-only, NEVER caches/tokens):
# - ~/.config/htop/      (htoprc)
# - ~/.config/iterm2/    (preferences plist)
# - ~/.config/git/       (ignore patterns, attributes)
# - ~/.config/opencode/  (config files; SKIP auth.json, sessions/)
# - ~/.config/Claude/    (config files; SKIP sessions/, todos/, projects/, anything containing api_key)
# - ~/.config/tfenv/     (tfenv config)
# - ~/.config/packer/    (packer config; SKIP plugins/ if huge)
# - ~/.config/stripe/    (stripe CLI config; SKIP credentials)

# Repo per-tool layout (so `cd stow && stow -t ~ <tool>` recreates ~/.config/<tool>/):
# stow/<tool>/.config/<tool>/<files>
# Note the case mismatch for Claude: ~/.config/Claude/ uses capital C; stow module dir is stow/claude/ (lowercase)
# but the inner ".config/Claude/" path MUST preserve the capital C to match the actual dir on disk.
</context>

<tasks>

<task type="auto">
  <name>Task 1: Inventory and create destination tree for all eight tool modules</name>
  <files>
    /Users/fwartner/dotfiles/stow/htop/.config/htop/,
    /Users/fwartner/dotfiles/stow/iterm2/.config/iterm2/,
    /Users/fwartner/dotfiles/stow/git/.config/git/,
    /Users/fwartner/dotfiles/stow/opencode/.config/opencode/,
    /Users/fwartner/dotfiles/stow/claude/.config/Claude/,
    /Users/fwartner/dotfiles/stow/tfenv/.config/tfenv/,
    /Users/fwartner/dotfiles/stow/packer/.config/packer/,
    /Users/fwartner/dotfiles/stow/stripe/.config/stripe/
  </files>
  <read_first>
    - Run a single inventory pass to see what actually exists (some tools may not have a ~/.config/<tool>/ dir on this machine):
      ```bash
      for tool in htop iterm2 git opencode Claude tfenv packer stripe; do
        echo "=== ~/.config/${tool} ==="
        if [ -d ~/.config/${tool} ]; then
          ls -la ~/.config/${tool} | head -20
          du -sh ~/.config/${tool}
        else
          echo "MISSING — skip this tool, note in summary"
        fi
      done
      ```
    - Confirm `rsync` is on PATH (`which rsync` — should be `/usr/bin/rsync` or homebrew's)
  </read_first>
  <action>
    Create the destination directory tree for every tool that exists on the source machine. Skip any tool whose source dir does not exist (record in SUMMARY).

    Note the case rule: the file system path `~/.config/Claude` uses capital `C`, so the destination must be `stow/claude/.config/Claude/` (module dir lowercase, target dir preserves caps).

    ```bash
    mkdir -p /Users/fwartner/dotfiles/stow/htop/.config/htop
    mkdir -p /Users/fwartner/dotfiles/stow/iterm2/.config/iterm2
    mkdir -p /Users/fwartner/dotfiles/stow/git/.config/git
    mkdir -p /Users/fwartner/dotfiles/stow/opencode/.config/opencode
    mkdir -p /Users/fwartner/dotfiles/stow/claude/.config/Claude
    mkdir -p /Users/fwartner/dotfiles/stow/tfenv/.config/tfenv
    mkdir -p /Users/fwartner/dotfiles/stow/packer/.config/packer
    mkdir -p /Users/fwartner/dotfiles/stow/stripe/.config/stripe
    ```

    DO NOT copy yet — Task 2 handles the copy with explicit excludes.
  </action>
  <verify>
    <automated>for d in htop iterm2 git opencode claude tfenv packer stripe; do test -d /Users/fwartner/dotfiles/stow/${d} || { echo "MISSING $d"; exit 1; }; done</automated>
  </verify>
  <acceptance_criteria>
    - All eight `stow/<tool>/.config/<tool>/` directory paths exist (empty is fine — copy happens in Task 2)
    - Inventory recorded: which source `~/.config/<tool>/` dirs exist on this machine and which do not
  </acceptance_criteria>
  <done>
    Destination tree ready. Inventory of which source dirs exist captured for the SUMMARY.
  </done>
</task>

<task type="auto">
  <name>Task 2: Rsync each tool's config-only content with explicit exclusion of caches/sessions/credentials</name>
  <files>
    /Users/fwartner/dotfiles/stow/htop/.config/htop/,
    /Users/fwartner/dotfiles/stow/iterm2/.config/iterm2/,
    /Users/fwartner/dotfiles/stow/git/.config/git/,
    /Users/fwartner/dotfiles/stow/opencode/.config/opencode/,
    /Users/fwartner/dotfiles/stow/claude/.config/Claude/,
    /Users/fwartner/dotfiles/stow/tfenv/.config/tfenv/,
    /Users/fwartner/dotfiles/stow/packer/.config/packer/,
    /Users/fwartner/dotfiles/stow/stripe/.config/stripe/
  </files>
  <read_first>
    - Re-run the inventory from Task 1 to confirm source contents have not changed mid-flight
    - For Claude and opencode specifically, list contents to spot anything that screams "credential":
      ```bash
      ls -la ~/.config/Claude/ 2>/dev/null
      ls -la ~/.config/opencode/ 2>/dev/null
      ls -la ~/.config/stripe/ 2>/dev/null
      ```
  </read_first>
  <action>
    Use `rsync -a` with explicit `--exclude` patterns for each tool. Trailing slashes on source paths copy contents (not the directory itself). Skip any tool whose source dir does not exist.

    Run one rsync per tool. The exclude patterns are tool-specific based on CONTEXT:

    **htop** — config is just `htoprc`; no exclusions needed:
    ```bash
    if [ -d ~/.config/htop ]; then
      rsync -av --delete-excluded \
        ~/.config/htop/ \
        /Users/fwartner/dotfiles/stow/htop/.config/htop/
    fi
    ```

    **iterm2** — preferences plist; exclude any cache/state files:
    ```bash
    if [ -d ~/.config/iterm2 ]; then
      rsync -av --delete-excluded \
        --exclude='*.cache' \
        --exclude='AppSupport/' \
        --exclude='SavedState/' \
        ~/.config/iterm2/ \
        /Users/fwartner/dotfiles/stow/iterm2/.config/iterm2/
    fi
    ```

    **git** (under .config — separate from the top-level ~/.gitconfig already captured in Plan 02) — ignore patterns and attributes:
    ```bash
    if [ -d ~/.config/git ]; then
      rsync -av --delete-excluded \
        --exclude='credentials' \
        --exclude='credential-cache/' \
        ~/.config/git/ \
        /Users/fwartner/dotfiles/stow/git/.config/git/
    fi
    ```

    **opencode** — config only; explicitly drop auth and sessions:
    ```bash
    if [ -d ~/.config/opencode ]; then
      rsync -av --delete-excluded \
        --exclude='auth.json' \
        --exclude='sessions/' \
        --exclude='cache/' \
        --exclude='*.log' \
        ~/.config/opencode/ \
        /Users/fwartner/dotfiles/stow/opencode/.config/opencode/
    fi
    ```

    **Claude** — config only; drop sessions/projects/todos/auth (per CONTEXT):
    ```bash
    if [ -d ~/.config/Claude ]; then
      rsync -av --delete-excluded \
        --exclude='sessions/' \
        --exclude='todos/' \
        --exclude='projects/' \
        --exclude='*.session' \
        --exclude='auth.json' \
        --exclude='credentials.json' \
        --exclude='*api_key*' \
        --exclude='*.log' \
        --exclude='cache/' \
        ~/.config/Claude/ \
        /Users/fwartner/dotfiles/stow/claude/.config/Claude/
    fi
    ```

    **tfenv** — version manager config; exclude downloaded Terraform binaries if the dir is a config dir (most tfenv state lives in $TFENV_ROOT, not ~/.config, so this is usually small):
    ```bash
    if [ -d ~/.config/tfenv ]; then
      rsync -av --delete-excluded \
        --exclude='versions/' \
        --exclude='*.tar.gz' \
        --exclude='*.zip' \
        ~/.config/tfenv/ \
        /Users/fwartner/dotfiles/stow/tfenv/.config/tfenv/
    fi
    ```

    **packer** — config; explicitly drop plugin binaries (per CONTEXT):
    ```bash
    if [ -d ~/.config/packer ]; then
      rsync -av --delete-excluded \
        --exclude='plugins/' \
        --exclude='cache/' \
        ~/.config/packer/ \
        /Users/fwartner/dotfiles/stow/packer/.config/packer/
    fi
    ```

    **stripe** — CLI config; drop credentials (per CONTEXT, capture structure only):
    ```bash
    if [ -d ~/.config/stripe ]; then
      rsync -av --delete-excluded \
        --exclude='credentials' \
        --exclude='*.key' \
        --exclude='cache/' \
        ~/.config/stripe/ \
        /Users/fwartner/dotfiles/stow/stripe/.config/stripe/
    fi
    ```

    After all eight rsyncs, run an audit pass to catch anything that slipped through:
    ```bash
    echo "=== files captured per module ==="
    for tool in htop iterm2 git opencode claude tfenv packer stripe; do
      count=$(find /Users/fwartner/dotfiles/stow/${tool}/.config -type f 2>/dev/null | wc -l | tr -d ' ')
      size=$(du -sh /Users/fwartner/dotfiles/stow/${tool}/.config 2>/dev/null | cut -f1)
      echo "${tool}: ${count} files, ${size}"
    done

    echo ""
    echo "=== suspicious filename audit (should be empty) ==="
    find /Users/fwartner/dotfiles/stow -type f \( \
      -iname '*token*' -o \
      -iname '*secret*' -o \
      -iname '*credential*' -o \
      -iname 'auth.json' -o \
      -iname '*.pem' -o \
      -iname '*.key' \
    \) 2>/dev/null
    ```

    If the suspicious-filename audit produces output, DELETE those files immediately and note in the SUMMARY which excludes need to be tightened.

    DO NOT:
    - Copy `versions/`, `plugins/`, `cache/`, `sessions/`, `todos/`, `projects/` directories
    - Copy any file matching `auth.json`, `credentials*`, `*token*`, `*.key`, `*.pem`
    - Try to sanitize file *contents* — that is Phase 2's job. This plan only excludes whole files/directories that are operational state or credentials.
    - Use `cp -r` instead of `rsync` — `rsync`'s `--exclude` is what makes the credential-blocking deterministic.
  </action>
  <verify>
    <automated>find /Users/fwartner/dotfiles/stow -type f \( -iname '*token*' -o -iname '*secret*' -o -iname '*credential*' -o -iname 'auth.json' -o -iname '*.pem' -o -iname '*.key' \) | tee /tmp/dotfiles-capture-suspicious.txt; test ! -s /tmp/dotfiles-capture-suspicious.txt</automated>
  </verify>
  <acceptance_criteria>
    - Each `stow/<tool>/.config/<tool>/` either contains the tool's main config file(s) or is empty (with a note in the SUMMARY explaining why the source dir was missing)
    - At minimum, if `~/.config/htop/htoprc` exists on the source, `stow/htop/.config/htop/htoprc` exists and `diff -q` shows no differences
    - The suspicious-filename audit (`find ... -iname 'auth.json' ...`) returns ZERO results across all of `stow/`
    - No `sessions/`, `todos/`, `projects/`, `plugins/`, `versions/`, `cache/` directories appear under any captured stow module: `find /Users/fwartner/dotfiles/stow -type d \( -name sessions -o -name todos -o -name projects -o -name plugins -o -name versions -o -name cache \)` returns empty
  </acceptance_criteria>
  <done>
    Eight tool config modules captured under `stow/`, with caches/sessions/credentials excluded by construction. CFG-01 through CFG-05 satisfied at the capture level; CFG-06 (formal exclusion via stow ignore patterns) is Phase 2's job and is not regressed by this capture.
  </done>
</task>

</tasks>

<verification>
Run from the repo root:

```bash
cd /Users/fwartner/dotfiles

# Every module dir must exist
for tool in htop iterm2 git opencode claude tfenv packer stripe; do
  test -d stow/${tool}/.config && echo "OK: stow/${tool}/" || echo "MISSING: stow/${tool}/"
done

# At minimum, htoprc must round-trip cleanly if source exists
[ -f ~/.config/htop/htoprc ] && diff -q ~/.config/htop/htoprc stow/htop/.config/htop/htoprc

# No credentials/sessions/caches should have leaked through
find stow -type f \( -iname '*token*' -o -iname '*secret*' -o -iname '*credential*' -o -iname 'auth.json' -o -iname '*.pem' -o -iname '*.key' \)
# Expected: no output

find stow -type d \( -name sessions -o -name todos -o -name projects -o -name plugins -o -name versions -o -name cache \)
# Expected: no output

# Total size should be small (configs, not application data)
du -sh stow/
# Expected: under a few MB unless iterm2 plist is unusually large
```

Both `find` commands MUST return empty. The `du -sh` should be small (low MB range).
</verification>

<success_criteria>
- All eight stow module destination directories exist
- Each module contains the tool's config files (or is documented as empty because source was missing)
- ZERO files matching credential/token/key/auth/secret patterns appear anywhere under `stow/`
- ZERO directories named `sessions/`, `todos/`, `projects/`, `plugins/`, `versions/`, `cache/` appear under `stow/`
- Total `du -sh stow/` is in the low-MB range (configs only, no application data)
- Requirements CFG-01, CFG-02, CFG-03, CFG-04, CFG-05 marked addressable
</success_criteria>

<output>
After completion, create `.planning/phases/01-capture/01-03-SUMMARY.md` documenting:
- Per-tool inventory: which source dirs existed, which did not, file counts and sizes per captured module
- Output of the suspicious-filename audit (must be empty)
- Output of the suspicious-directory audit (must be empty)
- Any tool whose excludes had to be tightened mid-flight
- Note: "Phase 2 will add `.stow-local-ignore` files per module (CFG-06) and review captured contents for any in-file secrets that excludes did not catch."
</output>
