---
name: tests
description: Use when writing, modifying, reviewing, or evaluating tests in any language — unit, integration, or end-to-end. Covers TDD discipline, black-box testing through public APIs, negative and error-path coverage, and naming.
---

# Tests

## Overview

Tests document *expected behaviour*, not implementation. They exercise the public API as a black box. Every feature or bugfix starts with a failing test.

**REQUIRED BACKGROUND:** Core TDD discipline — red/green/refactor, Iron Law, rationalization traps — lives in `superpowers:test-driven-development`. This skill layers project-style preferences on top.

## When to use

- Adding a new feature or fixing a bug (write the failing test first)
- Adding coverage to existing code
- Reviewing tests in a PR
- Evaluating whether existing tests are worth keeping

## Do

- **Follow TDD.** No production code without a failing test. See `superpowers:test-driven-development` for the full discipline.
- **Test through the public API.** Internals are invisible to tests.
- **Name tests after behaviour, not methods.** `TestParse_rejects_trailing_comma` beats `TestParse_error_1`.
- **Cover negative behaviour explicitly.** "X does *not* do Y" is as important as "X does Z".
- **Cover error paths**, not just happy paths. Timeouts, invalid input, partial failures.
- **Look for refactor opportunities on every green.** Tests give you the safety net — use it.
- **One behaviour per test.** If you need "and" in the test name, split it.
- **Arrange / Act / Assert structure.** Keep these three phases visually distinct (blank lines work fine, don't comment with these words).
- **Use fakes over mocks** where a hand-written stub with real logic is simple. Mocks that only assert call shape are fragile.
- **Only mock code you own.** Wrap third-party APIs in a thin adapter first, then fake the adapter.
- **Use language-native table/parametrized tests** for many similar cases.

## Don't

- **Don't test implementation details.** Internal helpers, private methods, field values.
- **Don't create 1:1 `foo.go` ↔ `foo_test.go` mappings as a rule.** Organize tests by *behaviour being tested*, not by file layout.
- **Don't write tests that pass immediately without a prior red.** A test you never saw fail proves nothing.
- **Don't skip negative cases** "because they're obvious". They're where real bugs hide.
- **Don't assert on log output** unless logging *is* the behaviour under test.
- **Don't share mutable state between tests.** Every test runs in isolation; use fresh fixtures.
- **Don't use "test" as a verb in the test name.** `TestFoo_does_X`, not `TestFoo_tests_X`.

## The loop

```
1. Pick the smallest behaviour you can describe in one sentence.
2. Write a test that asserts it. Run it. See red.
3. Write the minimum code to make it green.
4. Refactor — code and tests — with the green as your safety net.
5. Repeat.
```

If you skipped step 2, stop and delete what you wrote. Start over.

## Quick reference

| Need | Approach |
|------|----------|
| Many similar cases | Table / parametrized tests |
| External service | Wrap in adapter, fake the adapter |
| Filesystem | Temp dirs (`t.TempDir()`, `tmp_path`) |
| Time / clocks | Inject a clock; don't rely on real time |
| Randomness | Seed it or inject the source |
| Slow setup | Fixture-scoped (`module` / `session`) — but only if the work is truly shared |

## Black-box vs. implementation tests

```python
# Good — describes behaviour
def test_cache_returns_cached_value_on_second_call():
    c = Cache(loader=lambda k: object())
    first = c.get("x")
    second = c.get("x")
    assert first is second

# Bad — tests an internal detail
def test_cache_stores_value_in_dict():
    c = Cache(loader=lambda k: "v")
    c.get("x")
    assert c._storage == {"x": "v"}
```

The second test breaks the moment you change `_storage` to an LRU — but the behaviour is identical. That's a false signal.

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Writing the test after the code | Delete the code. Restart with a failing test. |
| Test name says `TestFoo_works` | Rename: *what* does it do? |
| One test, many unrelated assertions | Split per behaviour |
| Mocking your own pure function | Call the real function |
| Mocking a third-party library directly | Wrap it, then fake the wrapper |
| Asserting on private fields | Assert on public output or observable effects |
| Shared module-level fixtures mutating state | Scope the fixture to `function`, or make it immutable |
