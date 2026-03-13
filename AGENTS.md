# Dotfiles Repo

Manages Craig's macOS system configuration. Everything lives here and gets symlinked to where macOS expects it.

## Structure

```
Brewfile                  # Homebrew packages (the source of truth for installed tools)
install                   # Idempotent bootstrap script (symlinks, brew, Claude Code)
shell/profile             # PATH, aliases, functions (sourced by zshrc)
shell/zsh/                # zshenv, zprofile, zshrc -> symlinked to ~/.<name>
shell/analytics           # Telemetry opt-outs
readline/inputrc          # Terminal input defaults -> ~/.inputrc
git/gitconfig             # Git config -> ~/.gitconfig
git/gitignore_global      # Global gitignore -> ~/.gitignore_global
agents/                   # Shared agent config -> ~/.claude/ (instructions, skills)
claude/                   # Claude Code config -> ~/.claude/ (settings, hooks, agents)
ghostty/config            # Ghostty terminal config -> ~/.config/ghostty/config
bin/                      # Utility scripts -> ~/bin/
biome.json                # JS/TS formatter config
justfile                  # Task runner (just install, just test, just lint)
tests/                    # Shell and hook validation scripts
```

## Workflow for making changes

Always follow this workflow when modifying the dotfiles repo:

1. **Make the change** (see scenarios below)
2. **Show Craig what changed** — summarise the changes and ask for approval before committing
3. **Commit and push** — only after Craig approves. Commit to `main` with a clear message.

Never leave changes uncommitted. The GitHub repo should always reflect the current state of the machine.

### Installing a new tool

1. Add it to `Brewfile` in the appropriate category
2. Run `brew bundle --file=~/dotfiles/Brewfile`
3. If the tool needs config, create the config file in this repo and add a symlink to `install`
4. Show Craig, get approval, commit and push

### Changing existing config

1. Edit the file directly in this repo — symlinks mean the system reads from here already
2. Show Craig, get approval, commit and push

### Adding a new config file

1. Create the file in this repo under an appropriate directory
2. Add a `create_symlink` line to the `install` script
3. Run `~/dotfiles/install` to create the symlink
4. Show Craig, get approval, commit and push

## Conventions

- Brewfile is the source of truth for what's installed — don't `brew install` without adding to Brewfile
- All config lives in this repo, never edited directly in `~/` or `~/.config/`
- The install script is idempotent — safe to re-run anytime
- Existing files get backed up to `~/dotfiles/private/backup/` before being replaced
