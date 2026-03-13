# Global Claude Code Instructions

## About Craig

- Developer at Orbital Witness
- Primary editor: Cursor
- Terminal: Ghostty
- Always launches Claude Code with `--dangerously-skip-permissions`

## Terminal response formatting

1. Prefer numbered lists when they make it easier for Craig to reply to specific findings, options, recommendations, questions, or action items.
2. Use one numbered item per top-level reply-worthy point.
3. Keep one complete thought per numbered item. Do not break a single point into multiple numbers.
4. Examples, sub-steps, commands, and supporting detail should stay within the parent numbered item rather than becoming separate numbered items.
5. Do not flatten a hierarchy into sequential numbering when the child items are only supporting detail for a parent point.
6. When a response contains multiple numbered lists, **continue numbering sequentially** across all lists rather than restarting at 1. Every item in a response should have a unique number.
7. When a response includes decisions, options, recommendations, or next-step choices, give those items numbers in preference to background findings or supporting detail.
8. Number the points Craig is most likely to reply to directly. Do not spend numbers on context if the real reply targets are elsewhere in the response.
9. If a response ends with a choice, the available choices should be numbered.
10. These rules are for conversational output only — use whatever list style suits the document when writing file contents.

## Git & GitHub

- **Always prefer merge over rebase.**
- Never use `/` in branch names.

### Branch names

When a project spans multiple branches, use `project-N--piece` format (single dash before the number, double dash before the description). Examples:
- `auto-naming-1--design-doc`
- `auto-naming-2--database`
- `auto-naming-3--api`
- `billing-1--stripe-webhooks`
- `billing-2--invoice-pdf`

For standalone one-off changes, a plain descriptive name is fine (e.g. `fix-readme-typo`).

### PR titles

When a project spans multiple PRs, prefix the title with the project name and a sequence number (1, 2, 3...) indicating PR order: `Project 1 -- description`. Examples:
- `Auto-naming 1 -- Add name_source column and backfill migration`
- `Auto-naming 2 -- Wire name_source into creation, rename, and API responses`
- `Billing 1 -- Stripe webhook integration`
- `Billing 2 -- Invoice PDF generation`

For standalone PRs, a plain descriptive title is fine.

## Worktrees

Always use the `/worktrees-cr` skill for creating, switching to, or cleaning up worktrees. Do not freestyle git worktree commands.

## System-level changes

When installing system tools, changing shell config, or modifying machine-wide settings, read `~/dotfiles/AGENTS.md` first. That repo manages all system configuration and has specific instructions on how to make changes correctly.

Do not just run `brew install <package>` — there is a process to follow.
