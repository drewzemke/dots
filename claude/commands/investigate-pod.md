Investigate a Kubernetes pod error in production using kubectl.

The user has provided the following description of the issue: $ARGUMENTS

This may include the service name (or a grep-able substring) and optionally a brief description of what went wrong. If no service/pod name is included, search for pods whos name matches the current project directory.

## Step 1: Find the pod

Use `kubectl --context aws-prod get pods` and grep for the pod name from the description. Note the pod status, restarts, and age.

## Step 2: Check recent logs for errors

Pull recent logs from the pod(s) and filter for errors (level 50, level 40, "error", "Error"). If there are multiple replicas, check all of them.

If the logs are too large, use `--tail` and `--since-time` flags to narrow down. Start with `--tail=500` and filter from there.

## Step 3: Summarize findings

Report back with:
- Pod status (running, crashloop, etc.)
- The specific errors found, including timestamps and relevant context
- Any patterns (repeated errors, specific users/entities involved, related warnings)
- A brief assessment of whether this is an infrastructure issue, a code bug, or a data/permissions issue

## Step 4: Prepare for deeper investigation

Based on the errors found, suggest next steps. This might include:
- Looking at related pods that may have triggered the errors
- Examining the codebase for the relevant error paths
- Checking other infrastructure (databases, queues, etc.)

Ask the user how they'd like to proceed before diving deeper.
