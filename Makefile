.PHONY: help install stow unstow restow dry-run defaults scan

help:
	@echo "make install   - run full install.sh"
	@echo "make stow      - symlink all stow modules into \$$HOME"
	@echo "make unstow    - remove all stow symlinks from \$$HOME"
	@echo "make restow    - re-stow (refresh symlinks after adding new files)"
	@echo "make dry-run   - print what stow would do, change nothing"
	@echo "make defaults  - apply macOS defaults"
	@echo "make scan      - run the secret scanner"

install:
	./install.sh

stow:
	./scripts/stow-all.sh

unstow:
	./scripts/stow-all.sh --unstow

restow:
	./scripts/stow-all.sh --restow

dry-run:
	./scripts/stow-all.sh --dry-run

defaults:
	./macos/defaults.sh

scan:
	./scripts/scan-secrets.sh
