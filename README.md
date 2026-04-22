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
    ├── claude/.config/Claude/
    ├── git/.config/git/    # global gitignore
    ├── git/.gitconfig
    ├── tfenv/.config/tfenv/
    └── zsh/
        ├── .zprofile
        ├── .zshrc
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

- SSH and GPG **private keys** — never committed, even in private repos
- Active session credentials (`~/.config/gcloud`, `~/.config/hcloud`, gh tokens)
- iTerm2 binary `.plist` (machine-specific UUIDs; use iTerm2's custom-folder sync instead)
- Heavy app data (Herd config, lmstudio/ollama models, `~/Library/Application Support/*`)
- `~/Projects` source code (tracked in their own remotes)
- Browser profiles and extensions (browser sync handles these)
- Full `defaults export` dumps (brittle, noisy, unreviewable — `macos/defaults.sh` is a curated subset)

## License

MIT. See [LICENSE](LICENSE).
