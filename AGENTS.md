# Guidance for Agents

When working with my code:

1. **ALWAYS FOLLOW TDD** - No production code without a failing test. This is not negotiable.
2. **Think deeply** before making any edits
3. **Understand the full context** of the code and requirements
4. **Ask clarifying questions** when requirements are ambiguous
5. **Think from first principles** - don't make assumptions
6. **Assess refactoring after every green** - Look for opportunities to improve code structure, but only refactor if it adds value
7. **Keep project docs current** - Prefer adding/modifying sections of README.md to creating new files

## Behavior-Driven Testing

- Tests should verify expected behavior, treating implementation as a black box
- Test through the public API exclusively - internals should be invisible to tests
- No 1:1 mapping between test files and implementation files
- Tests that examine internal implementation details are wasteful and should be avoided
- Tests must document expected behaviour
- Tests must also validate "negative" behaviour e.g. "X should *NOT* do Y" as well as "positive" cases "X should do Z"
- Tests must also validate error paths, not just happy paths

## Code Style

Prefer Self-documenting code.

- Pure functions wherever possible
- No nested if/else - use early returns or composition
- Do not write organizational or comments that summarize the code. Comments should only be written in order to explain "why" the code is written in some way in the case there is a reason that is tricky / non-obvious.
- Prioritize code correctness and clarity. Speed and efficiency are secondary priorities unless otherwise specified.

## Communication

- Be explicit about trade-offs in different approaches
- Explain the reasoning behind significant design decisions
- Flag any deviations from these guidelines with justification
- Suggest improvements that align with these principles
- When unsure, ask for clarification rather than assuming

## Languages

### Go

#### Do

- Use table driven tests with a list of test case structs
  - Do this even when there is only one test case to allow for easy expansion in the future
  - Always prefer simple tables with minimal/no branching in the test body. The test case should be data in (typically a struct), expected out (also likely a struct) and any error expected
- Code must be formatted with `golangci-lint fmt ./...` and linted with `golangci-lint run ./... --fix` and must pass all checks
- Document all exported functions, types and packages
- Add `context.Context` to all blocking operations
- Use pointers carefully, only when data needs to be mutated or when needed by function signatures we do not control
- Propegate errors with `fmt.Errorf("<useful context>: %w", err)`
- When creating interfaces, prefer small, tightly focussed ones preferably with only 1 method. Then if needed, compose them to create larger interfaces
- Use the gopls mcp with `gopls mcp` to get LSP advice
- Prefer using `testdata/` with test data files rather than having them inline in the code
  - If there are multiple grouped scenarios, use sub directories underneath `testdata/`
- Tests must live in `{package}_test` packages and test only the exported API
- *ALWAYS* run the unit tests with the race detector: `go test -race ./...` not just `go test ./...`
- Use `filepath.Join` to construct file paths rather than string concatenation i.e. don't do `"testdata/" + "file.txt`

#### Don't Do

- Code should never panic, always proactively think through logical flow and if there is a chance of panic, write defensive code to prevent it
  - For example be careful with operations like indexing which may panic if the indexes are out of bounds
- Never explicitly `panic`, always handle an error instead
- Skip handling `context.Context` cancellation
- Create goroutines without clear lifecycle management - A goroutine must always be terminated deterministically
- Fix linting issues with `//nolint`, always try and fix them properly, use `//nolint` sparingly and only when absolutely necessary
- Write functions that mutate data in place, if mutation is needed, prefer functions that take data in, and return mutated data and an error (if applicable) out
  - i.e. instead of `func Downgrade(data *Data) error`, prefer `func Downgrade(data Data) (Data, error)`

### Python

#### Do

- All signatures must have complete type hints and pass a type checker like `mypy` or `ty`
- All code must pass linting with `ruff check` and be formatted with `ruff format`
- Use modern python idioms matching the Python version constraints in `pyproject.toml`
- Use context managers for resource handling
- Document all functions and classes with descriptive docstrings following the Google docstring style
- Use `uv` for all package management and virtual environment related tasks
- Use `typing.Protocol` for defining interfaces rather than asbtract base classes etc.
- Use `pytest` and pytest fixtures for testing

#### Don't

- Generate class hierarchies, prefer composition over inheritance
