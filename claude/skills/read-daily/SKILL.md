---
name: read-daily
description: >
  Read today's daily note to understand current tasks and context. Use at the start of any session involving work tasks, project planning, or when the user references something they're working on. Also provides awareness of project-specific notes for deeper context.
user-invocable: false
allowed-tools: Read
---

# daily note context

today's daily note:

!`sh ~/.claude/skills/read-daily/today.sh`

# project notes convention

deeper project notes live in `~/notes/` and follow naming conventions:
- named by topic (e.g., `rss-forms.md`, `rss-notifications.md`, `post-push-party.md`, `tongo.md`)
- check what files already exist to match naming conventions before creating new ones

when a conversation goes deep on a specific project, read the relevant project note(s) for more context. use the section headers in the daily note (e.g., `### forms`, `### notifications`) as an index of active work areas.

project notes contain dated entries (`## YYYY-MM-DD`) in reverse chronological order — a running journal of decisions, findings, and progress. some may be empty (just tag files); that's fine.

if the user is working on something that doesn't have a corresponding note file yet, briefly suggest creating one (e.g., "want me to start a note for this?"). if they accept, also add a `[[note-name]]` link in today's daily note where relevant. don't push it if they decline, and don't suggest it for small/trivial tasks.

# note style guide

when reading or referencing daily notes, understand these conventions:
- `- [ ]` incomplete task, `- [x]` completed, `- [n]` deprioritized/nevermind
- *italicized notes* indicate waiting/blocked states (e.g., `*waiting on v2 to be completely done*`)
- `[[wiki-links]]` reference other notes files
- jira tickets referenced inline in parens: `(PLATFORM-6229)`
- `#meeting` tags mark meeting notes
- `##` for major categories (work tasks, party), `###` for project areas (forms, notifications)
- tasks are hierarchically nested with indentation
- tone is casual and lowercase
