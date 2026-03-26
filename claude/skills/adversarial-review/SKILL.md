---
name: adversarial-review
description: Spin up an agent to perform an adversarial code review of recent work, trying to poke holes and expose potential issues.
user-invocable: true
---

Perform an adversarial code review of recent work in this conversation.

1. Gather context from the conversation: what task was being worked on, what decisions were made and why, and which commits contain the changes.
2. Launch an Agent to perform the review. Provide it with:
   - A summary of the task and the problem being solved
   - Key decisions and their reasoning
   - Which commits to inspect (use `jj diff -r <change_id>` or `git diff`)
   - Instructions to also read the current state of all changed files
3. The agent's review should be **adversarial** — it should actively try to find:
   - Logical errors or incorrect assumptions
   - Edge cases not handled (nulls, empty values, missing fields, etc.)
   - Migration safety issues (idempotency, data corruption, rollback scenarios)
   - Test coverage gaps
   - Behavioral changes beyond what was intended
   - Fragile patterns (hardcoded skip lists, implicit dependencies, etc.)
   - Security or performance concerns
4. Summarize the agent's findings back to the user, ranked by severity (HIGH/MEDIUM/LOW/INFO).

The review should be thorough but grounded — flag real risks, not hypothetical nitpicks.
