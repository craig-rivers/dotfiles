---
name: clean-branches-cr
description: Fetch, prune, and delete local branches whose remote tracking branch is gone. Also removes associated worktrees.
user_invocable: true
---

Run the following steps:

1. Fetch and prune remote tracking branches:

```bash
git fetch --prune
```

2. Find local branches whose upstream is gone:

```bash
git branch -vv | grep ': gone]' | awk '{print $1}'
```

3. For each branch found:
   - Check if a worktree exists for it: `git worktree list --porcelain | grep -B2 "branch refs/heads/$branch"`
   - If a worktree exists, remove it first: `git worktree remove <path>`
   - Delete the local branch: `git branch -d $branch`
   - If `-d` fails (unmerged), report it and ask whether to force-delete with `-D`

4. Run `git worktree prune --expire now` to clean up any stale worktree metadata.

5. Show a summary of what was cleaned up.
