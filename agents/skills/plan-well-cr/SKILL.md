---
name: plan-well-cr
description: Create an execution-ready plan with task breakdown, parallelization strategy, and completeness guarantees. Use instead of raw plan mode so the plan carries its own execution instructions.
user_invocable: true
---

## Determining scope

Check the user's arguments:

- **No arguments (`/plan-well-cr`)**: Plan everything — either all items in the most recent list, or the full discussion/design in conversation.
- **Numbered items (`/plan-well-cr 1,3,5`)**: Plan only the specified items.
- **Numbered exclusions (`/plan-well-cr not 2,4`)**: Plan all items except the specified ones.
- **Natural language (`/plan-well-cr just the API changes`, `/plan-well-cr not the CSS stuff`)**: Use the description to determine what's in or out of scope.

These can also be combined (e.g., `/plan-well-cr 1,3 and the error handling`).

Only plan items that are in scope. Out-of-scope items should not appear in the plan at all.

## No-skip rule

Every in-scope item must appear in the plan and be executed. Do not drop, skip, or deprioritize items because you disagree with them, think they're unnecessary, think the current code is fine, or think they match existing convention. Your job is to figure out *how* to do each item, not *whether* to do it.

Valid reasons to skip: genuinely blocked, requires user input, or destructive and user asked for confirmation. "I think the current approach is better" is NOT a valid reason to skip.

This rule applies to both planning and execution.

Then enter plan mode using EnterPlanMode.

## Planning phase

Explore the codebase thoroughly to understand what needs to change. Then write a plan with the structure below. The plan must be **self-executing** — when approved, it becomes the blueprint you follow. Don't write a vague description of changes; write a concrete execution plan.

### Plan structure

The plan must contain these sections:

#### Overview
One or two sentences on what this plan achieves.

#### Tasks

A numbered list of tasks. Each task must include:
- **A clear, verifiable deliverable.** "Update auth and fix the API and refactor utils" is too broad. "Update the JWT refresh logic in auth.ts" is right.
- **The files it touches.** This is critical for parallelization decisions.
- **A self-contained description of the work.** Include the actual changes to make, not references back to conversation items. This is critical — task descriptions are the source of truth during execution, and a task can only be safely delegated to a subagent if its description is complete enough to execute without conversation context.

Follow these grouping rules:
- **One deliverable, one file set.** Each task should touch a distinct set of files. If two items touch the same file, group them into one task.
- **Group tightly coupled items** where doing one naturally leads into the other.
- **Don't over-consolidate.** Independent items touching different files should be separate tasks.

#### Completeness

The plan must end with this exact block:

```
## Execution rules
- Create tasks using TaskCreate for every task listed above.
- Execute every task. The no-skip rule applies.
- Delegation: subagents are faster but less accurate (no conversation context).
  Use a parallel subagent when a task touches files no other task touches AND
  its description is fully self-contained. Execute inline when a task needs
  conversation context, iterative judgement, or shares files with other tasks.
  Sequential when tasks depend on each other's output.
- When done, provide a summary of completed and skipped items.
```

This block survives into execution and governs how you implement the plan after approval.

## Presenting the plan

Use ExitPlanMode to present the plan. The user will approve, reject, or give feedback.

## After approval

Follow the plan exactly as written, including the execution rules block. The plan is your instruction set — don't deviate from it unless you hit a genuine blocker.
