---
name: clean-branches-cr
description: Fetches latest remote state and deletes local branches whose remote has been deleted (e.g. after merging a PR).
user_invocable: true
---

## Your Task

Clean up stale local branches by running these steps in order:

1. **Fetch and prune remote tracking references**
   ```bash
   git fetch --prune
   ```

2. **List branches to identify any marked [gone]**
   ```bash
   git branch -v
   ```

3. **Remove worktrees and delete [gone] branches**
   ```bash
   git branch -v | grep '\[gone\]' | sed 's/^[+* ]//' | awk '{print $1}' | while read branch; do
     echo "Processing branch: $branch"
     worktree=$(git worktree list | grep "\\[$branch\\]" | awk '{print $1}')
     if [ ! -z "$worktree" ] && [ "$worktree" != "$(git rev-parse --show-toplevel)" ]; then
       echo "  Removing worktree: $worktree"
       git worktree remove --force "$worktree"
     fi
     echo "  Deleting branch: $branch"
     git branch -D "$branch"
   done
   ```

If no branches are marked as [gone], report that no cleanup was needed.
