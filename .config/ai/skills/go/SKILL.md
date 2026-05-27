---
name: go
description: Use when writing, modifying, reviewing, or reading Go code.
---

# Go

## Overview

Opinionated conventions for idiomatic, correct Go. Correctness beats performance. Code should never panic. Errors are values: wrap, don't swallow.

**RELATED SKILLS:** General test discipline (TDD, black-box testing, naming) lives in `tests` and `superpowers:test-driven-development`. This skill only adds Go-specific test mechanics.

## When to use

- Writing, modifying or reviewing any `.go` file (including `_test.go`)
- Designing a Go API or interface

## Do

- **Format + lint:** `golangci-lint fmt ./...` then `golangci-lint run ./... --fix`. Both must pass before ship.
- **Test with the race detector:** `go test -race ./...`. Plain `go test` is incomplete.
- **Document exported symbols.** Every exported func, type, var, const, and package gets a doc comment.
- **Wrap errors with `%w`,** never `%v`, when propagating. Inspect with `errors.Is` / `errors.AsType` (or `errors.As` pre-1.26). Use `errors.Join` to combine.
- **`ctx context.Context` is the first parameter** of every blocking / IO function, named `ctx`. Never store it in a struct. Return `ctx.Err()` promptly when `ctx.Done()` fires.
- **Every goroutine has a deterministic exit** via ctx cancel, a close signal, or completion. Prefer `errgroup.WithContext` over raw `go func()` + `chan error`.
- **Accept interfaces, return concrete types.** Define interfaces at the *consumer*, with the smallest possible surface, often one method. Compose small interfaces when you need more.
- **Consistent receivers per type:** all pointer or all value. Never mix.
- **Zero value should be useful.** Design types so a freshly declared value is usable without an init call.
- **Return new values, not mutations:** `func Downgrade(d Data) (Data, error)` over `func Downgrade(d *Data) error`. Use pointers only when mutation is the contract or a foreign signature forces it.
- **Prefer stdlib `slices` / `maps` / `cmp`** over hand-rolled helpers.
- **Build paths with `filepath.Join`**, never string concatenation.
- **Early returns over nested conditionals.**
- **Table-driven tests** with `[]struct{}`, even for a single case so expansion is cheap.
- **`{package}_test` package, fixtures in `testdata/`** (subdirectories for grouped scenarios). Test only the exported API.
- **`t.Helper()`, `t.Cleanup()`, `t.TempDir()`, `t.Parallel()`** in tests. Correct failure lines, automatic teardown, real concurrency under `-race`.

## Don't

- **Don't panic.** Bounds-check indexes, nil-check pointers that could be nil. Panics leak across package boundaries.
- **Don't discard errors with `_ = ...`.** Handle, wrap, or return. Silent discard hides bugs.
- **Don't silence linters with `//nolint`.** Fix the underlying issue. Reserve `//nolint` for the truly unfixable, with a comment explaining why.
- **Don't branch inside `t.Run` bodies.** Table tests are data-in → data-out. If cases differ enough to need branches, split them.
- **Don't close a channel from the receive side.** The sender owns the close.

## Rationalizations

| Excuse | Reality |
|--------|---------|
| "It can't be nil here" | Then a nil-check costs nothing. Panics in production cost everything. |
| "The goroutine is tiny, it'll finish" | Unsupervised goroutines outlive their caller. Wire `ctx` or a close signal. |
| "`%v` reads cleaner than `%w`" | `%v` flattens the error chain. Callers can't unwrap or `errors.Is`. |
| "Pointer to avoid the copy" | Almost always premature. Copying small structs is cheap. |
| "Export the interface so consumers can mock" | The consumer defines the interface it needs. The producer exports the concrete type. |
| "`//nolint` for now, I'll fix later" | Lint suppressions ossify. Fix the issue, or delete the code. |

## Quick reference

| Situation | Pattern |
|-----------|---------|
| Wrap an error | `fmt.Errorf("opening %s: %w", path, err)` |
| Match a sentinel | `errors.Is(err, io.EOF)` |
| Extract a typed error (1.26+) | `e, ok := errors.AsType[*MyErr](err)` |
| Extract a typed error (pre-1.26) | `var e *MyErr; errors.As(err, &e)` |
| Combine errors | `errors.Join(err1, err2)` |
| Build a file path | `filepath.Join("testdata", "case.json")` |
| Bounded concurrency | `g, ctx := errgroup.WithContext(ctx)` |
| Temp dir in test | `dir := t.TempDir()` |
| Register cleanup | `t.Cleanup(func() { ... })` |
| Mark a helper | `t.Helper()` (first line) |
| Run subtests in parallel | `t.Parallel()` inside `t.Run` |
| Sort a slice | `slices.Sort(s)` |

## Error-wrapping pattern

```go
// Good: chain preserved, unwrappable with errors.Is / errors.As.
if err := os.Open(path); err != nil {
    return fmt.Errorf("opening %s: %w", path, err)
}

// Bad: chain broken, callers can't inspect the cause.
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
            t.Parallel()
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
