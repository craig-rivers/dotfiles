---
name: plan-well-cr
description: Creates execution-ready plans with task breakdown, parallelisation strategy, and completeness guarantees.
user_invocable: true
---

Enter plan mode and create a thorough, execution-ready plan for the work described.

## Planning Process

1. **Understand the goal**: Read the user's request carefully. If anything is ambiguous, ask for clarification before planning.
2. **Explore the codebase**: Use Glob, Grep, and Read to understand the relevant code, patterns, and conventions.
3. **Design the approach**: Consider multiple approaches and choose the best one. Explain trade-offs if relevant.
4. **Break into tasks**: Decompose the work into discrete, independently verifiable tasks.
5. **Identify parallelism**: Note which tasks can be done in parallel vs which have dependencies.
6. **Write the plan**: Present a clear, ordered list of tasks with enough detail that each could be handed to a subagent.

## Plan Requirements

- Each task must be self-contained: include file paths, function names, and enough context to execute without referring back to the conversation.
- Include a verification step for each task (how to confirm it worked).
- Include an overall verification step at the end.
- **No skipping**: Every aspect of the user's request must be covered. If something seems out of scope, flag it explicitly rather than silently omitting it.

## Output

Present the plan and use ExitPlanMode to request approval before execution begins.
