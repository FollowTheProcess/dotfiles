---
name: tests
description: Use when writing, modifying, reviewing, or evaluating tests in any language (unit, integration, or end-to-end). Covers TDD discipline, black-box testing through public APIs, negative and error-path coverage, and naming.
---

# Tests

## Overview

Tests document *expected behaviour*. They exercise the public API as a black box, so they survive refactors and read as a spec for what the code promises. Every feature or bugfix starts with a failing test.

**REQUIRED BACKGROUND:** Core TDD discipline (red/green/refactor, the Iron Law, rationalization traps) lives in `superpowers:test-driven-development`. This skill layers project-style preferences on top.

## When to use

- Adding a new feature or fixing a bug (write the failing test first)
- Backfilling coverage on existing code
- Reviewing tests
- Deciding whether an existing test is worth keeping

## Do

- **Failing test first.** No production code without a prior red. A test you never watched fail proves nothing. See `superpowers:test-driven-development`.
- **Test through the public API.** Internals are invisible to tests. If you can't reach a behaviour from outside, it isn't one worth pinning.
- **Name tests after behaviour, not methods.** `parses_trailing_comma_as_error` beats `test_parse_1`. If the name needs "and", split the test.
- **Cover the negative path explicitly.** "X does *not* do Y" carries the same weight as "X does Z". This is where real bugs hide.
- **Cover error paths,** not just happy ones: timeouts, invalid input, partial failures, cancellation.
- **One behaviour per test.** Arrange / Act / Assert as three visually distinct blocks (blank lines, not comments).
- **Fakes over mocks** when a small hand-written stub with real logic will do. Mocks that only assert call shape stay green when the real API drifts.
- **Only mock code you own.** Wrap a third-party API in a thin adapter, then fake the adapter.
- **Use the language's native table / parametrized form** for many similar cases. One body, many rows.
- **Refactor on green.** The passing test is your safety net. Use it on production code *and* the tests themselves.
- **Every test is independent.** Fresh fixtures, no shared mutable state, no inter-test ordering.

## Don't

- **Don't test implementation details:** internal helpers, private methods, field values. They change without changing behaviour.
- **Don't mirror source files 1:1 in tests.** Organize by *behaviour being tested*, not by file layout.
- **Don't skip negative cases** because they feel obvious. The obvious ones are where regressions land.
- **Don't assert on log output** unless logging *is* the behaviour under test.
- **Don't use "test" as a verb in the test name.** `parses_x`, not `tests_parsing_x`.
- **Don't mock a third-party library directly.** Wrap it; fake the wrapper.
- **Don't mock your own pure functions.** Call them.
- **Don't share mutable state between tests.** Every test starts from a fresh fixture.

## Rationalizations

| Excuse | Reality |
|--------|---------|
| "This change is too small for a test" | Then the test is too small to skip. The cost is seconds; the regression isn't. |
| "I'll write the test after, same outcome" | Tests-after answer *what does this do?*. Tests-first answer *what should this do?*. Different artefacts, different bugs found. |
| "Easier to assert on the private field" | The public API is missing an affordance. Fix that, not the test. |
| "Mocking is faster than a fake" | Until the mocked call shape drifts. Then every test stays green while production breaks. |
| "Happy path is enough" | Production runs the negative path on every bad input. Untested = unspecified. |
| "I manually verified it works" | Not repeatable, not reviewable, won't catch the regression six months out. |
| "It's flaky, just add a retry" | Flakiness is a race or shared state. Retries hide it; they don't fix it. |

## Quick reference

| Need | Approach |
|------|----------|
| Many similar cases | Language-native table / parametrized form |
| External service | Adapter you own; fake the adapter |
| Filesystem | Per-test temp dir (`t.TempDir()`, `tmp_path`) |
| Time / clocks | Inject a clock; never call wall-clock APIs in code under test |
| Randomness | Seed it or inject the source |
| Slow setup | Fixture-scoped only if truly shared and immutable |
| Flaky test | Find the race or shared state; never `@retry` |

## Black-box vs. implementation

```python
# Good. Pins the contract; survives refactors.
def test_cache_returns_same_value_on_second_call():
    c = Cache(loader=lambda k: object())
    first = c.get("x")
    second = c.get("x")
    assert first is second

# Bad. Pins the storage shape, not the contract.
def test_cache_stores_value_in_dict():
    c = Cache(loader=lambda k: "v")
    c.get("x")
    assert c._storage == {"x": "v"}
```

The second test fails the moment you swap the dict for an LRU, even though the behaviour is identical. That's a false signal that punishes the refactor it should have enabled.

## The 12 Desiderata

Kent Beck's 12 test desiderata defines standards that must be upheld for all software tests and a bar that all tests should be assessed against.

- **Isolated**: Tests don't affect each other, order doesn't matter, shared state is reset
- **Composable**: Tests can run in any subset or combination without breaking
- **Fast**: The suite runs in seconds, not minutes, fast enough to run on every save
- **Inspiring**: A passing suite genuinely increases confidence that the software works
- **Writable**: Adding a new test is cheap, low ceremony, good helpers, clear patterns
- **Readable**: A test communicates what it's testing and why it might fail
- **Behavioral**: Tests describe what the system does, not how it's implemented internally
- **Structure-insensitive**: Refactoring internals doesn't break tests unless behavior changes
- **Automated**: No human steps needed, tests run in CI and locally with one command
- **Specific**: A failing test pinpoints the exact problem, not just "something broke"
- **Deterministic**: Tests always produce the same result, no flakiness, no timing-dependent behavior
- **Predictive**: Passing tests are a reliable signal that production will work
