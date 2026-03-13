---
name: audit-cr
description: Runs an architectural complexity audit on the codebase using Ousterhout's "A Philosophy of Software Design" principles.
user_invocable: true
---

Use the Task tool to spawn an ousterhout-codebase-review agent.

Pass along any specific files, modules, or areas the user wants audited. If no specific scope is given, the agent should analyze the overall codebase architecture.
