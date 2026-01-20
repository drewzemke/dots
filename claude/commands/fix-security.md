Look up and address security alerts in this repo. Create one atomic commit per fix.

## Step 1: Check for Alerts

Run these commands in parallel to check both alert types:

```bash
# dependabot alerts
gh api repos/{owner}/{repo}/dependabot/alerts --jq '.[] | select(.state == "open") | {number, type: "dependabot", dependency: .dependency.package.name, severity: .security_advisory.severity, summary: .security_advisory.summary, patched: .security_vulnerability.first_patched_version.identifier}'

# code scanning alerts
gh api repos/{owner}/{repo}/code-scanning/alerts --jq '.[] | select(.state == "open") | {number, type: "code-scanning", rule: .rule.id, severity: .rule.security_severity_level, description: .rule.description, file: .most_recent_instance.location.path, line: .most_recent_instance.location.start_line}'
```

## Step 2: Prioritize

Address alerts in this order:
1. Critical severity
2. High severity
3. Medium severity
4. Low severity

## Step 3: Fix Each Alert

### For Dependabot alerts:
1. Determine where the dependency comes from (direct vs transitive)
2. If direct: update the version constraint
3. If transitive: try to resolve the issue by updating a direct dependency. *As a last resort*, use the package manager's override/resolution mechanism
4. Update the lockfile
5. Verify the vulnerable version is no longer present

### For Code Scanning alerts:
1. Read the flagged file and understand the vulnerability
2. Fix the code issue according to the rule description

## Step 4: Verify and Commit

After each individual fix:
1. Run the project's build, lint, and type-check commands to verify correctness
2. Commit with message format: `fix(deps): <brief description of fix>` or `fix(security): <description>` for code issues
3. Move to the next alert

## Notes

- Use `jj` for version control, not git
- Keep commits atomic (one fix per commit)
- If an alert can't be fixed (e.g., no patch available), report it and move on
