# Guidance for Agents

I use [nushell](https://www.nushell.sh), you can run `Bash` commands as normal but when giving *me* a shell command for me run, ensure it's `nushell` syntax

## General Coding Guidelines

- Always follow TDD
- Think deeply and understand the full context
- If you're unsure: ask me
- Don't make assumptions, find facts
- Keep docs current
- Use pure functions whenever possible
- Prefer early returns to nesting
- Correctness beats performance
- Comments explain *why* in weird cases, let code be it's own documentation

Language- and task-specific conventions live in skills under `~/.claude/skills/` (e.g. `writing-go`, `writing-python`, `writing-tests`) and load automatically when relevant.
