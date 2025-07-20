Create a "ticket" based on the following issue: $ARGUMENTS.

To create a ticket, run `fish -c "ticket add {kebab-case-title}"`, where you fill in the title. This will automatically create a new ticket file, which you must now fill in.

## Required Ticket Structure

### Header (Required)
```markdown
# Ticket #{number}: {Title}

**Date:** {Month Day, Year}
**Priority:** {High|Medium|Low}
**Estimated Effort:** {time estimate}
```

### Required Sections

1. **Problem Statement** (Required)
   - Clear description of the issue or need
   - Explains WHY this work is needed

2. **Description** (Optional)
   - More detailed explanation of the work
   - Provides additional context

3. **Acceptance Criteria** (Required)
   - Use `- [ ]` checkbox format
   - Specific, testable requirements
   - What must be true when complete

4. **Implementation Details** (Optional but recommended)
   - Technical approach suggestions
   - Specific files to modify
   - Code examples when helpful

5. **Definition of Done** (Required)
   - Final completion checklist
   - MUST include: `- [ ] Code passes linting (pnpm lint:fix or cargo clippy, depending on the project)`
   - MUST include: `- [ ] Code passes type checking (pnpm check or cargo build)`

## Formatting Rules

- **Checkboxes**: Always use `- [ ]` format for task lists
- **File paths**: Wrap in backticks (`` `src/app/page.tsx` ``)
- **Code blocks**: Use triple backticks with language specification
- **Emphasis**: Use `**text**` for important metadata
- **Line references**: Include specific line numbers when relevant

## Priority Guidelines

- **High**: Critical bugs, core functionality, blocking issues
- **Medium**: Important improvements, refactoring, new features
- **Low**: Nice-to-have features, cleanup, optimizations

## Effort Estimation

Use simple time ranges:
- **Minutes**: `30 minutes`, `45 minutes`
- **Hours**: `1 hour`, `2 hours`, `1-2 hours`
- **Large tasks**: `2-3 hours` (consider breaking down if longer)
