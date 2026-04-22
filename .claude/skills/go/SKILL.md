---
name: go
description: Use when writing, modifying, reviewing, or reading Go code — new .go files, test files, modules, or packages. Covers formatting, linting, error wrapping, table-driven tests, context handling, and goroutine lifecycle.
---

# Go

## Overview

Opinionated conventions for idiomatic, correct Go. Correctness beats performance. Code should never panic. Errors are values — wrap, don't swallow.

## When to use

- Writing or modifying any `.go` file (including `_test.go`)
- Reviewing Go code
- Designing a Go API or interface
- Project-level conventions in `CLAUDE.md` / `AGENTS.md` override anything here.

## Do

- **Format + lint:** `golangci-lint fmt ./...` then `golangci-lint run ./... --fix`. Must pass before ship.
- **Run tests with the race detector:** `go test -race ./...` — never plain `go test`.
- **Document exported symbols:** every exported func, type, var, const, and package gets a doc comment.
- **Wrap errors with `%w`:** `fmt.Errorf("loading config: %w", err)`. Never `%v` when propagating.
- **Check wrapped errors with `errors.Is` / `errors.AsType`:** never `==` on errors that may be wrapped.
- **Table-driven tests:** use a `[]struct{}` even for a single case so expansion is cheap.
- **Put tests in `{package}_test`:** test only the exported API.
- **Store fixtures in `testdata/`:** subdirectories for grouped scenarios.
- **Build paths with `filepath.Join`** — never string concatenation.
- **Use `t.Helper()`, `t.Cleanup()`, `t.TempDir()`** in test helpers. Correct failure lines and teardown by default.
- **Pass `context.Context` to every IO blocking operation** and honor cancellation.
- **Prefer small, single-method interfaces**, compose them when you need more.
- **Prefer stdlib `slices` / `maps` / `cmp`** over hand-rolled helpers (Go 1.21+).
- **Return new values, not mutations:** `func Downgrade(d Data) (Data, error)` over `func Downgrade(d *Data) error`. Use pointers only when mutation is the contract or a foreign signature forces it.
- **Early returns over nested conditionals.**

## Don't

- **Don't panic.** Bounds-check indexes, nil-check pointers that could be nil. Panics leak across package boundaries.
- **Don't spawn goroutines without a deterministic exit path.** Every goroutine must terminate via `ctx` cancel, a close signal, or completion.
- **Don't silence linters with `//nolint`.** Fix the underlying issue. Use `//nolint` only when truly unfixable or the fix adds noise, with a comment explaining why.
- **Don't branch inside `t.Run` bodies.** Table tests are data-in → data-out. If cases differ enough to need branches, split them.

## Quick reference

| Situation | Pattern |
|-----------|---------|
| Wrap an error | `fmt.Errorf("context: %w", err)` |
| Match a sentinel error | `errors.Is(err, io.EOF)` |
| Extract a typed error | `var e *MyErr; errors.As(err, &e)` |
| Build a file path | `filepath.Join("testdata", "case.json")` |
| Temp dir in test | `dir := t.TempDir()` |
| Register cleanup | `t.Cleanup(func() { ... })` |
| Mark a helper | `t.Helper()` as first line |
| Empty interface | `any` (not `interface{}`) |
| Sort a slice | `slices.Sort(s)` |

## Error-wrapping pattern

```go
// Good — chain preserved, unwrappable with errors.Is/As.
if err := os.Open(path); err != nil {
    return fmt.Errorf("opening %s: %w", path, err)
}

// Bad — chain broken, callers can't inspect the cause.
if err := os.Open(path); err != nil {
    return fmt.Errorf("opening %s: %v", path, err)
}
```

## Table-test pattern

```go
func TestParse(t *testing.T) {
    cases := []struct {
        name    string
        in      string
        want    Config
        wantErr error
    }{
        {name: "empty", in: "", want: Config{}, wantErr: nil},
        {name: "invalid yaml", in: "!!!", want: Config{}, wantErr: ErrInvalid},
    }

    for _, tc := range cases {
        t.Run(tc.name, func(t *testing.T) {
            got, err := Parse(tc.in)
            if !errors.Is(err, tc.wantErr) {
                t.Fatalf("err: got %v, want %v", err, tc.wantErr)
            }
            if diff := cmp.Diff(tc.want, got); diff != "" {
                t.Errorf("mismatch (-want +got):\n%s", diff)
            }
        })
    }
}
```

## Common mistakes

| Mistake | Fix |
|---------|-----|
| `go test ./...` without `-race` | Add `-race` always |
| `fmt.Errorf("...: %v", err)` | Use `%w` to preserve the chain |
| `err == ErrNotFound` on wrapped err | `errors.Is(err, ErrNotFound)` |
| Declaring `interface{}` | Use `any` |
| Complex logic in `t.Run` body | Split into separate tests or a helper |
| `//nolint` to paper over lint | Fix the issue; comment if truly unfixable |
| Mutating input arguments | Return a new value |
| Goroutine with no exit condition | Wire up `ctx.Done()` or a close channel |
