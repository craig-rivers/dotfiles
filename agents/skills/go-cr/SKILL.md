---
name: go-cr
description: Execute findings, recommendations, or discussed plans from the current conversation. Use when ready to stop discussing and start doing. This skill is for execution, not planning — don't reference it during plan mode.
user_invocable: true
---

Review the current conversation to understand what needs to be executed.

## Determining scope

Check the user's arguments: no arguments means execute everything; numbered items (`/go-cr 1,3,5`) or exclusions (`/go-cr not 2,4`) select specific items; natural language (`/go-cr just the API changes`) filters by description. These can be combined.

If the conversation contains a numbered list of findings or recommendations, those are the work items. If there's no list but there's been a discussion or design conversation, synthesize what was agreed upon into concrete items. If genuinely ambiguous, ask — but prefer using your judgement.

## No-skip rule

Execute every in-scope item. Do not skip items because you disagree with them, think they're unnecessary, think the current code is fine, or think they match existing convention. The user decided what to do — your job is to do it.

Valid reasons to skip: genuinely blocked, requires user input, or destructive and user asked for confirmation. "I think the current approach is better" is NOT a valid reason to skip.

## Task creation

Create tasks using TaskCreate to track progress. Every work item should be accounted for in a task — the point of tasks is making sure nothing gets lost.

- **A clear, verifiable deliverable.** "Update auth and fix the API and refactor utils" is too broad. "Update the JWT refresh logic in auth.ts" is right.
- **One deliverable, one file set.** Each task should touch a distinct set of files. If two items touch the same file, group them into one task.
- **Group tightly coupled items** where doing one naturally leads into doing the other.
- **Don't over-consolidate.** Independent items touching different files should be separate tasks even if they're small. A task with too many unrelated items leads to things being missed.
- **Task descriptions must be self-contained.** Include the actual work to be done, not references back to conversation items (e.g., "do item 3"). A task can only be safely delegated to a subagent if its description is complete enough to execute without conversation context.

## Delegation

Subagents are faster but less accurate — they lack conversation context and start cold. Use this to decide:

- **Inline**: tasks that need conversation context, require iterative judgement, or share files with other tasks.
- **Parallel subagents**: independent tasks that touch disjoint file sets and have fully self-contained descriptions. When delegating, include the no-skip rule and any relevant constraints in the subagent prompt.
- **Sequential**: tasks that depend on each other's output.

## General guidance

- Prefer doing the work over discussing it — the user has already decided to proceed.
- **Destructive or hard-to-reverse changes** (database migrations, deleting files, refactoring core abstractions): flag with a one-line heads-up *before* executing, then proceed unless the user intervenes. Don't block on confirmation unless the user asks you to.
- **Everything else**: execute as specified. If something looks risky but isn't destructive, flag it briefly and keep going. Flagging is not permission to change the approach.
- Don't re-explain findings back to the user — they've already seen them.

## Verification

After completing all tasks, verify the work: run relevant tests, check for syntax errors, or confirm the changes work as expected. Don't skip verification just because the changes look correct.

## When done

Provide a brief summary:

### Completed
Numbered list of items fully completed with file:line references where relevant.

### Partially completed
Numbered list (continuing from above) of items where some but not all work succeeded, with what worked and what didn't.

### Skipped
Numbered list (continuing from above) of anything not done and why (e.g., "blocked by X", "requires user input", "failed — error details").
