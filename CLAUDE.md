<!-- GSD:project-start source:PROJECT.md -->
## Project

**dotfiles**

A personal dotfiles repository that captures Florian Wartner's macOS development environment — Homebrew taps/formulae/casks, Mac App Store apps, shell configuration, tool configs, and curated macOS defaults — with a single `install.sh` that provisions a new Mac into a 1:1 clone of the source machine.

**Core Value:** Running `./install.sh` on a fresh macOS install must produce a fully working development environment without manual intervention. If anything else breaks, this must not.

### Constraints

- **Tech stack**: Bash (not zsh) for `install.sh` — portable, works during bootstrap before zsh customizations are loaded
- **Compatibility**: Must run on a vanilla macOS install (no tools pre-installed other than whatever Apple ships)
- **Security**: Repo is intended for a **public** GitHub remote — every committed file must be safe to publish; no tokens, no `@pixelandprocess.de`, no Fastlane secrets
- **Idempotence**: Every script step must be safe to re-run (brew install skips installed packages; stow re-links cleanly; defaults writes are declarative)
- **No company identity**: All references to Pixel & Process, `pixelandprocess.de`, and P&P-specific paths/agents/tools must be excluded
<!-- GSD:project-end -->

<!-- GSD:stack-start source:STACK.md -->
## Technology Stack

Technology stack not yet documented. Will populate after codebase mapping or first phase.
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

Conventions not yet established. Will populate as patterns emerge during development.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
<!-- GSD:architecture-end -->

<!-- GSD:skills-start source:skills/ -->
## Project Skills

No project skills found. Add skills to any of: `.claude/skills/`, `.agents/skills/`, `.cursor/skills/`, or `.github/skills/` with a `SKILL.md` index file.
<!-- GSD:skills-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd-quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd-debug` for investigation and bug fixing
- `/gsd-execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd-profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
