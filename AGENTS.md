# Guidance for Agents

Global guidance for all Agents, regardless of current project.

- Application/tool config is managed via ~/dotfiles and nix/nix-darwin. Never try and imperitively change configuration.
- Unless I explicitly tell you to commit, git commits will be handled by me either during or at the end of a task. You should not commit.
- Documentation changes must be run through the humanizer skill and corrected if needed

## General Coding Guidelines

- Always follow TDD
- Think deeply and understand the full context
- If you're unsure: ask me
- Don't make assumptions, find facts
- Keep docs current on changes
- Use pure functions whenever possible
- Prefer early returns to nesting
- Correctness beats performance
- Comments explain _why_ in weird cases, do not over-comment, let code be it's own documentation
  - Where you do comment, keep them concise
- Use the language specific skills for more details about a specific language's standards
