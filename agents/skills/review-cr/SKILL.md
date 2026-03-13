---
name: review-cr
description: Reviews code changes through parallel specialized agents with validation. Use before creating PRs or when reviewing changesets.
user_invocable: true
---

Three-phase code review: context preparation, parallel specialized review, and validation filtering.

**Note**: Using separate subagents helps maintain objectivity — they review the code fresh without the context of having written it.

## Modes

Check the user's arguments to determine the mode:

### Default mode (`/review-cr`, `/review-cr <scope>`)

Report-only. Run all three phases, then present validated findings in the Output format below. Do not make any edits.

### Self mode (`/review-cr self`, `/review-cr self <scope>`)

Act on the review. Run all three phases, but after Phase 2 returns:

1. **Think critically** about every validated recommendation. The agents may still be wrong even after validation. For each finding, decide:
   - Is this actually correct?
   - Is this worth changing, or is it a nitpick?
   - Will this change improve the code or just churn it?

2. **Action the good ones.** Make the edits yourself for findings you judge to be correct and worthwhile. Skip the rest. Be opinionated — you're the senior engineer here, not the subagents.

3. **Briefly summarize** what you changed and what you deliberately skipped (and why).


## Phase 0: Context Preparation

You (the skill runner) do this directly — no agent needed.

1. **Get the diff**: Run the appropriate `git diff` command and capture the output:
   - Default (no arguments): `git diff main` — includes committed, staged, and unstaged changes vs main
   - User provides a branch or commit range: use that as the diff target
   - User provides a PR number: use `gh pr diff <number>`
   - User provides specific files: scope the diff accordingly
2. **Discover guideline file paths**: Search for `AGENTS.md` files and `docs/ADRs/*.md` with Glob. Pass the paths (not content) to agents — they'll read the ones relevant to their domain.
3. **Run tests, linting, and type checking**: Check `README.md` or project config (e.g., `package.json`, `Makefile`, `justfile`) for how to run these. Execute them and capture the output. Include the results (pass/fail + relevant output) in the context package passed to Phase 1 agents.
4. **Triage the changeset**: Analyze the diff to determine which agents to spawn:
   - **What file types changed?** Categorize as: production code, test code, config/infra, docs
   - **How large is the change?** Count lines added/removed
   - **Selection rules**:
     - No test files changed -> skip jaley-tests
     - No production code changed (only docs, config, or infra) -> skip correctness + security
     - Only docs/markdown changed -> run simplify only
     - < 20 lines of production code changed -> skip ousterhout (architectural concerns need scale)
   - Always run at minimum: simplify + one domain-relevant agent
5. **Build context package**: Embed the full diff text, guideline file paths, and test/lint/typecheck results directly in every Phase 1 agent's prompt. Agents do not compute diffs themselves — they work from the context you provide.

## Phase 1: Parallel Review

Spawn the selected agents **in a single message** with multiple Agent tool calls. Set `max_turns: 30` on each agent to prevent runaway execution. Each agent receives the diff context, guideline file paths, and scope. The full roster (spawn all that passed triage):

1. **Simplify agent** (`subagent_type: "simplify"`) — Tactical concerns: clarity, consistency, naming, readability. Instruct it to use **read-only mode**.

2. **Ousterhout code review agent** (`subagent_type: "ousterhout-code-review"`) — Strategic concerns: module depth, information hiding, interface design, abstraction boundaries, layer quality, convention compliance.

3. **Jaley correctness agent** (`subagent_type: "jaley-correctness"`) — Runtime correctness: bugs, race conditions, logic errors, performance, database, scalability.

4. **Jaley security agent** (`subagent_type: "jaley-security"`) — Safety & risk: OWASP Top 10, privacy, insecure defaults, code hygiene.

5. **Jaley tests agent** (`subagent_type: "jaley-tests"`) — Test trustworthiness: test efficacy, mocking hygiene, assertion quality, coverage gaps.

Jaley-correctness and jaley-security intentionally analyze the same production code through different analytical frames. A race condition might be flagged by correctness as "bug" and by security as "DoS vector." The validator deduplicates these.

## Phase 2: Normalize + Validate

After all Phase 1 agents complete:

### Normalize findings

Convert all Phase 1 findings into a uniform format:

```
## Finding [N]
- Source: [agent name]
- Severity: [BLOCKER/HIGH/MEDIUM/LOW]
- File: [path:line]
- Description: [what's wrong]
- Recommendation: [how to fix]
```

### Validate

Spawn the validation agent:

- **Review validator** (`subagent_type: "review-validator"`, `max_turns: 30`) — Pass it the normalized findings and the diff context. It deduplicates, independently reads cited code, and returns per-finding VALIDATED/SUGGESTION/REJECTED verdicts.

## Input

Pass along any context the user provides:
- PR number or branch name (use `git diff` to get changes)
- Specific files or directories
- Commit range (e.g., `main..HEAD`)

If no scope is given, default to all changes on the current branch vs the main branch (committed, staged, and unstaged). Use context to infer the right scope — e.g., if you just finished working on something, review that.

## Output

After Phase 2 completes, present **validated** findings and **suggestions** organized by category:

### Summary
Brief overall assessment of code quality. Note which agents ran (and which were skipped by triage, if any). Include the validation rate (e.g., "12 findings from 4 agents -> 8 unique -> 5 validated, 2 suggestions (63% validated)").

### Findings

**Simplification Opportunities**
- Validated findings from the simplify agent
- Each with file:line reference and what could be improved

**Complexity Concerns**
- Validated findings from ousterhout-code-review
- Each with the relevant principle violation and specific code location

**Production Risk**
- Validated findings from jaley-correctness
- Each with severity, file:line reference, and recommendation

**Security & Compliance**
- Validated findings from jaley-security
- Each with severity, file:line reference, and recommendation

**Test Quality**
- Validated findings from jaley-tests
- Each with severity, file:line reference, and recommendation

Omit any category with no validated findings.

### Suggestions (optional)
Lower-confidence findings worth considering. Listed with file:line reference and brief description. Omit if none.

### Verdict
- **Approve**: No blocking issues, minor suggestions only
- **Request Changes**: Issues that should be addressed before merge
- **Needs Discussion**: Architectural concerns requiring team input

In **self mode**, append:

### Changes Made
- List each edit with file:line reference and brief rationale

### Deliberately Skipped
- List skipped suggestions with brief reason (e.g., "nitpick", "disagree — current approach is clearer", "not worth the churn")
