---
name: worktrees-cr
description: Set up or clean up isolated git worktrees for working on a separate branch without disturbing the current one.
user_invocable: true
---

Set up an isolated git worktree so the user can work on a separate branch without leaving their current one.

## Arguments

Parse the user's input to determine:

- **Task description** — what the work is for. Use this to generate a branch name following the project's branch naming conventions.
- **Start point** — where to branch from. Defaults to `main` if not specified.
- **Existing branch** — if the user names a branch that already exists (local or remote), check it out instead of creating a new one.

Examples:
- `/worktrees-cr fix the login bug` -> new branch from `main`, name derived from description
- `/worktrees-cr fix login bug from develop` -> new branch from `develop`
- `/worktrees-cr fix-login-bug` -> if branch exists, check it out; if not, create it from `main`

## Setup

1. Verify `.worktrees/` is gitignored in the project:

```bash
git check-ignore -q .worktrees 2>/dev/null
```

If not ignored, add `.worktrees/` to `.gitignore` and commit the change before proceeding.

2. Fetch latest remote state:

```bash
git fetch
```

3. If `.worktrees/<branch-name>` already exists, report that the worktree is already set up and ask the user if they want to `cd` into it. Don't recreate it.

4. Create the worktree:

```bash
# New branch (default — branches from main or specified start point)
git worktree add .worktrees/<branch-name> -b <branch-name> <start-point>
cd .worktrees/<branch-name>

# Existing branch
git worktree add .worktrees/<branch-name> <branch-name>
cd .worktrees/<branch-name>
```

5. Copy editor config example files so formatters work correctly in the worktree:

```bash
# Copy any .example.json editor configs to their active names
for example_file in .zed/settings.example.json .vscode/settings.example.json; do
  if [ -f "$example_file" ]; then
    cp "$example_file" "${example_file%.example.json}.json"
  fi
done
```

6. Install dependencies if the project has them:

```bash
# Detect from project files
[ -f package.json ] && npm install
[ -f Cargo.toml ] && cargo build
[ -f requirements.txt ] && pip install -r requirements.txt
[ -f pyproject.toml ] && poetry install
[ -f go.mod ] && go mod download
```

7. Run tests to verify a clean baseline. If tests fail, report failures and ask whether to proceed.

8. Report the worktree path and test status.

## Cleanup

When the user asks to close/remove/clean up a worktree, **discover the paths dynamically** — do not reconstruct them from memory.

### Step 1 — Find the main repo root and current worktree path

```bash
# The first entry in worktree list is always the main repo
main_root=$(git worktree list --porcelain | head -1 | sed 's/^worktree //')
current=$(git rev-parse --show-toplevel)
echo "main: $main_root"
echo "current: $current"
```

If this fails (CWD no longer exists), escape to a known-good directory first:

```bash
cd ~ && main_root=$(git -C <any-known-repo-path> worktree list --porcelain | head -1 | sed 's/^worktree //')
```

### Step 2 — cd to main repo root, then remove

You **must cd out of the worktree first.** If your CWD is inside a deleted directory, every subsequent shell command will fail.

```bash
cd "$main_root"
git worktree remove --force "$current" 2>/dev/null; git worktree prune --expire now; git worktree list
```

This handles all edge cases in one line:
- `remove --force` cleanly removes the worktree and its metadata, even if the directory is already gone or has uncommitted changes. Errors are suppressed because the next command catches anything it misses.
- `prune --expire now` catches edge cases where `remove` fails (e.g. corrupted `.git` file inside the worktree). The `--expire now` flag is needed because git's default prune expiry is 3 months.
- `worktree list` verifies the worktree is gone. **This is your success check** — do not retry based on stderr output from the earlier commands.

The branch and its commits remain in git — only the working directory is removed.
