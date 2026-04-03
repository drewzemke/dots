---
name: audit-overrides
description: Audit dependency override/resolution pins to find which ones are still necessary. Spins up parallel agents in worktrees to test each pin independently.
argument-hint: [package-manager-audit-command]
---

Audit every dependency override/resolution pin in this project to determine which are still necessary.

Override mechanisms vary by package manager (e.g. pnpm `overrides`, npm `overrides`, yarn `resolutions`). Detect which one this project uses.

## Step 1: Establish a Baseline

Run the project's audit tool (e.g. `pnpm audit`, `npm audit`, `yarn audit`) and record the current vulnerability count and details. This is the baseline that agents will compare against.

If the user provided an argument, use that as the audit command instead of the default.

## Step 2: Launch Parallel Agents

For each override pin, launch a separate Agent with `isolation: "worktree"` and `run_in_background: true`. All agents should be launched in a single message to maximize parallelism.

Each agent's task:
1. Remove **only** its assigned override from the package manifest
2. Install dependencies (with lockfile updates allowed)
3. Run the audit tool
4. Compare results against the baseline:
   - If **new** vulnerabilities appear beyond the baseline, the pin is still needed. Report **KEEP** with details on what vulns appeared.
   - If results match or improve on the baseline, the pin is obsolete. Report **REMOVE**.
5. Do **not** create any commits — just report the verdict.

## Step 3: Collect and Summarize

As agents complete, track results. Once all are done, present a summary table:

| Override | Verdict | Details |
|----------|---------|---------|

## Step 4: Apply Removals

Ask the user if they'd like to apply the removals. If yes:
1. Edit the package manifest to remove all REMOVE-verdict overrides in one shot
2. Reinstall dependencies
3. Re-run the audit to confirm no regressions
4. Run the project's build/compile/typecheck to catch non-security breakage (like type conflicts from version mismatches)
5. If verification passes, commit the change
6. If verification fails, investigate and resolve before committing

## Notes

- If worktree creation fails, fall back to testing overrides sequentially in the main working copy (remove, test, restore, repeat)
- Some overrides exist for non-security reasons (e.g. type compatibility). The audit tool won't catch these — the build step in Step 4 will.
