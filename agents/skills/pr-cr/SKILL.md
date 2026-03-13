---
name: pr-cr
description: Commits work, pushes branch, and opens a pull request against main.
user_invocable: true
---

Run the following steps:

1. Check `git status` and `git diff` to understand what needs to be committed.
2. Stage the relevant files (not `git add -A` — be selective).
3. Commit with a clear, descriptive message.
4. Push the branch to origin with `-u` flag.
5. Create a pull request using `gh pr create`:
   - Use the project's PR template if one exists (check `.github/pull_request_template.md`)
   - Write a clear title (under 70 characters)
   - Write a description summarising the changes
   - Target `main` as the base branch (unless the user specifies otherwise)

Show Craig the PR URL when done.
