---
name: resume-prep
description: >
  Prepare or update a resume variant for a job application. Use when the user wants to create a new
  resume variant, tailor an existing one to a specific role, or review a resume against a job description.
user-invocable: true
---

# resume prep

Help the user prepare a resume variant for: $ARGUMENTS

## context

Resume files live in `~/notes/`. Here are the current variants and changelogs:

!`find ~/notes -name "resume-*.md" | sort`

## rules

1. **never invent experience** — only use bullets describing things the user has actually done. if unsure, ask.
2. **start from an existing variant** — don't write from scratch. ask the user which resume to base off of, or recommend one.
3. **maintain a changelog** — every resume variant has a `resume-changelog-<variant>.md` that tracks changes from the base. create one for new variants. format: dated entries with before/after diffs and rationale.
4. **reorder before rewriting** — prefer changing bullet order over changing bullet wording. only reword when the original wording actively misleads for the target role.
5. **show your work** — when proposing changes, explain what you're doing and why. don't just silently rewrite.
6. **check in before big moves** — get user approval before dropping bullets, adding new ones, or restructuring sections.

## workflow

1. read the target job description (user provides it)
2. read existing resume variants to understand what's available
3. recommend a base variant and discuss strategy
4. make changes iteratively — reorder first, then adjust wording, then add/remove bullets
5. run `/adversarial-review` at the end to stress-test the result against the JD

## resume structure

resumes use this general structure:
- technical skills (grouped by category)
- professional experience (bullet points under role/company)
- education
- selected project (optional)
- additional experience
- languages

## things to watch for

- bullets that actively undermine the target narrative (eg. pure dev bullets on a QA resume)
- missing keywords the user actually HAS experience with but isn't surfacing
- skills section keywords that don't match the target role family
- bullet order — strongest/most-relevant bullets first
- space allocation — is the resume spending its real estate on the right things?
