---
name: review-cr
description: Three-phase code review pipeline — prepare context, spawn parallel review agents, normalise and validate findings.
user_invocable: true
---

Run a structured code review in three phases. Accept an optional mode argument:

- **Default mode** (no argument, or "report"): Report findings only. Do not make edits.
- **Self mode** ("self"): After reporting, act on validated findings by making the fixes.

## Phase 0 — Prepare Context

1. Get the diff: `git diff` for unstaged changes, or `git diff HEAD~1` for the last commit, or as specified by the user.
2. Read project guidelines: check for `AGENTS.md`, `CLAUDE.md`, `docs/ADRs/*.md`, and any relevant convention files.
3. Run tests, linting, and type checking. Capture results.
4. Triage the diff: identify which files changed and categorize them (source code, tests, config, docs).

## Phase 1 — Parallel Review Agents

Spawn 5 review agents in parallel using the Task tool, each with subagent_type matching their agent name:

1. **simplify** — code clarity and maintainability (read-only mode)
2. **ousterhout-code-review** — complexity analysis
3. **jaley-correctness** — runtime correctness
4. **jaley-security** — safety and risk
5. **jaley-tests** — test trustworthiness

Pass each agent:
- The diff
- Relevant guideline file paths
- Test/lint/type-check results (for jaley-tests)

## Phase 2 — Normalise and Validate

1. Collect all findings from Phase 1.
2. Spawn the **review-validator** agent with all findings.
3. Present the validated findings to Craig, grouped by severity.

If in **self mode**, proceed to fix validated findings with severity MEDIUM or above.
