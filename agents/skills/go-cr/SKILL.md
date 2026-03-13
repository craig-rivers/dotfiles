---
name: go-cr
description: Execute agreed work items from the conversation. Supports numbered items, exclusions, and natural language scoping.
user_invocable: true
---

Execute the work items that have been agreed in the conversation. Parse the user's input to determine scope:

- **Numbered items**: "do 1, 3, 5" or "do 1-5" or "do all except 2"
- **Natural language**: "do the database changes" or "implement the API endpoint"
- **All items**: "do all" or "go" with no arguments means do everything agreed

## Rules

1. **No skipping**: Every item in scope must be completed. If you cannot complete an item, stop and explain why — do not silently skip it.
2. **Create tasks**: Use TaskCreate for each work item to track progress.
3. **Parallel where possible**: Use the Task tool to delegate independent items to subagents running in parallel.
4. **Verify results**: After completing each item, verify it works (run tests, check for errors, etc.).
5. **Self-contained descriptions**: When delegating to subagents, provide complete context — they cannot see the conversation history.

## Process

1. Parse the user's input to determine which items are in scope
2. Create a task for each item
3. Execute items, parallelizing where dependencies allow
4. Verify each item after completion
5. Report a summary of what was done

If no specific scope is given, the agent will focus on recently modified code.
