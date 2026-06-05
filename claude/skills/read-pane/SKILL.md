---
name: read-pane
description: This session runs inside zellij with multiple panes open. Other panes may have servers, watchers, test runners, command output, or other useful context. Use this skill to read their output whenever another pane's content could help with the current task — debugging, understanding state, checking results, etc.
user-invocable: false
---

Read the screen output of another zellij pane to help with the current task.

## Available panes

!`zellij action list-panes --tab --command --json | jq '.[] | { id, title, pane_command, pane_cwd }'`

## Steps

1. Pick the pane from above whose command/title is most relevant to the current task.
2. Run `zellij action dump-screen --pane-id <ID>` to read its recent viewport output. Optionally pass `--path /file/path` to send the output to a file.
3. If the viewport doesn't have enough context, retry with `--full` and focus on the last ~100 lines.
4. Analyze the output for errors, stack traces, or relevant log lines, and use them to inform your debugging.
