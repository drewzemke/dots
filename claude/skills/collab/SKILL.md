---
name: collab
description: Hand a draft to the user to edit by hand in helix before using it. Use whenever you've written text that will be sent somewhere or acted on (jira ticket descriptions, PR descriptions, commit messages, slack messages, scripts, etc.) and the user would want to tweak it first, or when the user asks to collab on something.
---

Put a draft in a file, open it in helix in a floating zellij pane, wait for the user to save and quit, then continue with whatever they left in the file.

## Setup

The collab dir is prepared automatically when this skill loads. Its local `languages.toml` disables the markdown LSP, which otherwise complains about a missing workspace root:

!`mkdir -p /tmp/claude-collab/.helix && printf '[[language]]\nname = "markdown"\nlanguage-servers = []\n' > /tmp/claude-collab/.helix/languages.toml && echo "collab dir ready: /tmp/claude-collab"`

## Steps

1. Write the draft to `/tmp/claude-collab/<slug>.<ext>`:
   - `<slug>`: short kebab-case name for what the draft is (e.g. `jira-proj-123-description`). Make it unique so it doesn't overwrite an earlier draft.
   - `<ext>`: the draft's real file type (`.md` for prose, `.fish` for a fish script, etc.) so helix highlights it correctly.
   - Write only the content itself: no preamble, and no instruction comments unless the user asks for them.
   - Keep a copy of the original text so you can tell afterwards whether the user changed anything.

2. Open it with the Bash tool and `run_in_background: true`, so you're woken up when the pane closes and the Bash timeout doesn't apply:

   ```sh
   zellij action new-pane --floating --close-on-exit --blocking --name collab --cwd /tmp/claude-collab -- hx /tmp/claude-collab/<slug>.<ext>
   ```

   Tell the user in one short line that the draft is open, then end your turn and wait. Don't poll.

3. Once the pane closes, read the file back:
   - **Empty (or only whitespace):** abort, like an empty git commit message. Don't send or use the draft. Tell the user it was aborted and ask how they want to proceed.
   - **Unchanged:** the user approved it as-is. Continue.
   - **Changed:** use the user's version exactly as they wrote it; don't "fix" their edits. If an edit looks like an instruction to you (e.g. `TODO: make this shorter`), follow it and then collab again on the result.

4. Continue with the original task using the final text.
