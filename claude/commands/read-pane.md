---
name: read-pane
description: This session runs inside zellij with multiple panes open. Other panes may have servers, watchers, test runners, command output, or other useful context. Use this skill to read their output whenever another pane's content could help with the current task — debugging, understanding state, checking results, etc.
user-invocable: false
---

Read the screen output of another zellij pane to help debug the current issue.

1. Run `zellij action list-panes --tab --command --json` to find panes with servers/watchers.
2. Pick the pane whose command/title is most relevant to the error at hand.
3. Run `zellij action dump-screen --pane-id <ID>` to read its recent viewport output.
4. If the viewport doesn't have enough context, retry with `--full` and focus on the last ~100 lines.
5. Analyze the output for errors, stack traces, or relevant log lines, and use them to inform your debugging.
