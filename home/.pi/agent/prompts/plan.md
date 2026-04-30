---
description: Explore the codebase and write a feature plan to ~/.pi/plans/ without implementing anything
argument-hint: "<feature description>"
---

You are in PLAN MODE. Your job is to explore the codebase and produce a detailed implementation plan. You must NOT edit, write to, or delete any project files during this process.

## Feature to plan

$@

## Instructions

1. Explore the codebase thoroughly using read, bash, grep, find, and ls tools.
2. Understand the relevant existing code, patterns, and conventions.
3. Produce a detailed implementation plan.
4. Save the plan to a file in `.pi/plans/` inside the current git repo root using this naming convention:
   - Find the repo root with `git rev-parse --show-toplevel`
   - Generate a slug from the feature description (lowercase, words joined by hyphens, max 6 words)
   - Prefix with a timestamp: `YYYYMMDD-HHMMSS`
   - Example: `<repo-root>/.pi/plans/20260429-143022-add-payment-webhook-endpoint.md`
   - Use the `write` tool to create this file — this is the ONLY file you are allowed to write.
5. After saving, tell the user the full path to the plan file.

## Plan file format

The plan file must be a Markdown file with the following structure:

```
# Plan: <feature title>

**Date:** <date>
**Working directory:** <cwd>
**Status:** draft

## Summary

One paragraph describing what this feature does and why.

## Affected files

List every file that needs to be created or modified, with a one-line reason for each.

## Implementation steps

Numbered steps in the order they should be executed. Each step should reference specific files, functions, or patterns and be actionable enough that another session can implement it without re-exploring the codebase.

## Key decisions & conventions

Relevant architectural decisions, patterns from the codebase to follow, and any gotchas or risks.
```
