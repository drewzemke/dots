---
name: update-daily
description: >
  Update today's daily note. Use when: a task is completed during the session, new tasks or subtasks emerge from work, the user asks to note something, or something noteworthy comes up about a project. Also update relevant project notes in ~/notes/ when architectural decisions, debugging findings, or other significant project context emerges.
allowed-tools: Read, Edit, Write
---

# update daily note

update today's daily note at `~/notes/daily/$(date +%Y-%m-%d).md` based on: $ARGUMENTS

## rules

1. **read the note first** before making any changes
2. **match the existing style exactly** — see style guide below
3. **be surgical** — only change what's relevant, don't reorganize or reformat existing content
4. **preserve everything else** — don't remove or modify entries you aren't updating
5. for new tasks, place them under the correct existing section/subsection
6. for completed tasks, just change `[ ]` to `[x]` — don't remove them
7. for new sections, follow the existing hierarchy pattern (`##` category, `###` project)

## style guide

- task format: `- [ ]` incomplete, `- [x]` completed, `- [n]` not doing
- lowercase, casual tone — no periods on task items
- parenthetical context inline: `(PLATFORM-6229)`, `(see planning docs)`
- italicized blockers/waits: `*waiting on deployment...*`
- wiki links for cross-references: `[[other-note]]`
- jira tickets in parens after task description
- hierarchical nesting with 2-space indentation
- keep it brief — drew's notes are terse, not verbose
- no emoji, no capitalized sentences in task items
- meeting notes get `#meeting` tag and use `###` for subsections (goals, questions)

## project notes

when something noteworthy happens during a session (architectural decision, debugging finding,
migration progress, a tricky problem solved, or a plan that changed), add a dated entry to
the relevant project note in `~/notes/`. check existing files to match the naming convention.

### format for project note entries

project notes use dated `## YYYY-MM-DD` headers in reverse chronological order (newest first).
entries go under today's date header, creating one if it doesn't exist yet.

```
## 2026-02-17

- decided to hold off on X until Y is done
- found the bug — missing scope on the API request
```

keep entries terse and casual, same style as the daily note. if the file is empty or doesn't
exist yet, just start with today's date header. don't add a top-level `#` title — the filename
is the title.
