---
name: coverage-cr
description: Comprehensive testing strategy audit across all test types. Use when you want a thorough review of test coverage for a project or module.
user_invocable: true
---

Use the Task tool to spawn a general-purpose agent with subagent_type "general-purpose".

The agent should perform a comprehensive testing strategy audit covering:

1. **Unit tests**: Function/method-level coverage for business logic
2. **Integration tests**: Component interaction and database query coverage
3. **End-to-end tests**: Critical user flow coverage
4. **Contract tests**: API contract and schema validation
5. **Snapshot tests**: UI component and serialization output stability
6. **Property-based tests**: Invariant checking for complex logic
7. **Performance tests**: Load testing and benchmark coverage
8. **Security tests**: Authentication, authorization, and input validation
9. **Smoke tests**: Basic health check and deployment verification

For each test type, the agent should report:
- Current coverage status (exists/missing/partial)
- Specific gaps identified
- Priority recommendation (critical/important/nice-to-have)
- Suggested test cases to add

Pass along any specific files, modules, or scope the user mentions.
