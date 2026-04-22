# dotfiles

Personal macOS dotfiles. One script bootstraps a fresh Mac into a working dev environment — Homebrew packages, Mac App Store apps, zsh, oh-my-zsh, modular shell config, sane macOS defaults, all symlinked via GNU stow.

## Bootstrap a new Mac

```bash
git clone https://github.com/fwartner/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

That's it. The script is idempotent — re-running on a provisioned machine is safe.

### What `install.sh` does

1. Verifies macOS, picks the right Homebrew prefix (`/opt/homebrew` on Apple Silicon, `/usr/local` on Intel)
2. Installs Xcode Command Line Tools (if missing) — accept the GUI prompt, then re-run
3. Installs Homebrew (if missing)
4. Runs `brew bundle` — installs every tap, formula, cask, and Mac App Store app from `Brewfile`
5. Clones oh-my-zsh (if missing)
6. Backs up any conflicting existing dotfiles to `<file>.pre-dotfiles.<timestamp>`, then stows every module from `stow/` into `$HOME`
7. Sets zsh as the default login shell (if not already)
8. Applies curated macOS defaults from `macos/defaults.sh`
9. Prints a post-install checklist

### Try before applying

```bash
./install.sh --dry-run
```

## Layout

```
.
├── Brewfile                # taps, formulae, casks, mas apps (one source of truth)
├── install.sh              # bootstrap script (bash, idempotent)
├── Makefile                # convenience targets
├── .env.example            # template for ~/.env.local (secrets)
├── .gitignore              # blocks secrets, history, OS junk
├── macos/
│   └── defaults.sh         # curated macOS defaults
├── scripts/
│   ├── stow-all.sh         # stow/unstow/restow/dry-run wrapper
│   └── scan-secrets.sh     # secret detection (12 patterns)
└── stow/                   # GNU stow modules — each mirrors $HOME layout
    ├── claude/.config/Claude/                 # Claude Desktop MCP config
    ├── claude-code/.claude/settings.json      # Claude Code (CLI) hooks, env, permissions
    ├── containers/.config/containers/         # podman containers.conf
    ├── cursor/Library/Application Support/Cursor/User/settings.json
    ├── flutter/.config/flutter/               # tool_state
    ├── gh/.config/gh/config.yml               # GitHub CLI prefs (no token; hosts.yml excluded)
    ├── git/.config/git/ignore                 # global gitignore
    ├── git/.gitconfig
    ├── iterm2/Library/Preferences/com.googlecode.iterm2.plist
    ├── oh-my-zsh/.oh-my-zsh/custom/{plugins,themes}/
    ├── prjct/.config/prjct/config.yaml        # personal project templates
    ├── tfenv/.config/tfenv/version
    └── zsh/
        ├── .zprofile
        ├── .zshrc
        ├── .iterm2_shell_integration.zsh
        └── .zsh.d/         # aliases, exports, functions, laravel, docker, flutter, k8s, infra
```

Each `stow/<module>/` mirrors what its target should look like under `$HOME`. Stowing `stow/zsh` symlinks `~/.zshrc`, `~/.zprofile`, and `~/.zsh.d/*.zsh` back into the repo.

## Common tasks

```bash
make help           # list targets
make stow           # symlink modules into $HOME
make unstow         # remove symlinks
make restow         # refresh after adding new files
make dry-run        # show what stow would do, change nothing
make defaults       # apply macOS defaults
make scan           # secret scan (run before pushing)
```

## Adding a new package

```bash
brew install <pkg>           # install on this machine first
brew bundle dump --force --describe --file=Brewfile  # re-export
git add Brewfile && git commit -m "feat: add <pkg>"
```

## Secrets — `~/.env.local`

This repo is intentionally public. Real secrets live outside the repo in `~/.env.local`, which is gitignored and sourced by `stow/zsh/.zsh.d/exports.zsh` at shell startup.

```bash
cp .env.example ~/.env.local
chmod 600 ~/.env.local
$EDITOR ~/.env.local         # fill in real values
```

`scripts/scan-secrets.sh` greps for 12 known secret patterns. Run before every push:

```bash
make scan
```

## Post-install checklist

After `install.sh` finishes, the script prints these manually-required steps:

1. **Sign in to the Mac App Store**, then re-run `brew bundle --file=Brewfile` if `mas` apps were skipped (sign-in is required to install MAS apps)
2. **Populate `~/.env.local`** from `.env.example`
3. **Import SSH keys** from your secure backup into `~/.ssh/` (chmod 700 the dir, 600 the keys)
4. **Import GPG keys** if you sign commits
5. **iTerm2 prefs**: open iTerm2 → Settings → General → Preferences → "Load preferences from a custom folder", point at wherever you sync the `com.googlecode.iterm2.plist`
6. **Restart your shell**: `exec zsh -l`

## What's intentionally NOT in this repo

**Secrets:**
- SSH and GPG **private keys**
- `~/.aws/credentials`, `~/.config/gcloud/`, `~/.config/hcloud/cli.toml` — live tokens
- `~/.config/gh/hosts.yml` — has the GitHub OAuth token (only `config.yml` is captured)
- `~/.config/gws/client_secret.json` — Google OAuth client secret
- `~/.config/stripe/config.toml` — live Stripe API keys
- `.env`, `.env.local`, `~/.env.local` — runtime secrets (use `.env.example` as a template)

**Heavy app data / runtime state:**
- Herd config, lmstudio/ollama models, podman VM disks
- `~/.config/configstore/` — npm tool runtime state (regenerated)
- `~/.config/psysh/`, `~/.config/cagent/`, `~/.config/patrol_cli/`, `~/.config/companies.sh/` — machine-specific UUIDs / first-run flags
- Cursor/VSCode `globalStorage`, `workspaceStorage`, `History` — per-machine state
- Shell history, log files, `.DS_Store`, `.zcompdump-*`

**Other:**
- Pixel & Process tooling, agents, identity (user directive)
- `~/Projects` source code (tracked in their own remotes)
- Browser profiles and extensions (browser sync handles these)
- Full `defaults export` dumps (brittle; `macos/defaults.sh` is a curated subset)

## License

MIT. See [LICENSE](LICENSE).
