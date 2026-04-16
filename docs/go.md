# Go

## Do

- Use table driven tests with a list of test case structs
  - Do this even when there is only one test case to allow for easy expansion in the future
  - Always prefer simple tables with minimal/no branching in the test body. The test case should be data in (typically a struct), expected out (also likely a struct) and any error expected
- Code must be formatted with `golangci-lint fmt ./...` and linted with `golangci-lint run ./... --fix` and must pass all checks
- Document all exported functions, types and packages
- Add `context.Context` to all blocking operations and handle context cancellation gracefully
- Use pointers carefully, only when data needs to be mutated or when needed by function signatures we do not control
- Propegate errors with `fmt.Errorf("<useful context>: %w", err)`
- When creating interfaces, prefer small, tightly focussed ones preferably with only 1 method. Then if needed, compose them to create larger interfaces
- Prefer using `testdata/` with test data files rather than having them inline in the code
  - If there are multiple grouped scenarios, use sub directories underneath `testdata/`
- Tests must live in `{package}_test` packages and test only the exported API
- *ALWAYS* run the unit tests with the race detector: `go test -race ./...` not just `go test ./...`
- Use `filepath.Join` to construct file paths rather than string concatenation i.e. don't do `"testdata/" + "file.txt"`

## Don't Do

- Code should never panic, always proactively think through logical flow and if there is a chance of panic, write defensive code to prevent it
  - For example be careful with operations like indexing which may panic if the indexes are out of bounds
- Create goroutines without clear lifecycle management - A goroutine must always be terminated deterministically
- Fix linting issues with `//nolint`, always try and fix them properly, use `//nolint` sparingly and only when absolutely necessary
- Write functions that mutate data in place, if mutation is needed, prefer functions that take data in, and return mutated data and an error (if applicable) out
  - i.e. instead of `func Downgrade(data *Data) error`, prefer `func Downgrade(data Data) (Data, error)`
- Have complex branching or logic in `t.Run` blocks. Table tests should be input -> test -> output (+ error)
