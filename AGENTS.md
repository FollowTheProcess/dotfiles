# Guidance for Agents

Global guidance for all Agents, regardless of current project.

- I use [nushell](https://www.nushell.sh), you can run `Bash` commands as normal but when giving *me* a shell command to run, ensure it's `nushell` syntax
- Never use Em dashes (—) or En dashes (–)
- Most application/tool config is managed via [GNU stow](https://www.gnu.org/software/stow/) from `~/dotfiles` (flat layout). Check there first when suggesting config changes.
- Unless I explicitly tell you to commit, git commits will be handled by me either during or at the end of a task. You should not commit.

## General Coding Guidelines

- Always follow TDD
- Think deeply and understand the full context
- If you're unsure: ask me
- Don't make assumptions, find facts
- Keep docs current on changes
- Use pure functions whenever possible
- Prefer early returns to nesting
- Correctness beats performance
- Comments explain *why* in weird cases, do not over-comment, let code be it's own documentation
  - Where you do comment, keep them concise
- Use the language specific skills for more details about a specific language's standards
