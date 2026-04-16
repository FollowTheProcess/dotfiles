# Testing


- Always follow TDD - No production code without a failing test
- Tests should verify expected behavior, treating implementation as a black box
- Test through the public API exclusively - internals should be invisible to tests
- No 1:1 mapping between test files and implementation files
- Tests that examine internal implementation details are wasteful and should be avoided
- Tests must document expected behaviour
- Tests must also validate "negative" behaviour e.g. "X should *NOT* do Y" as well as "positive" cases "X should do Z"
- Tests must also validate error paths, not just happy paths
- Look for refactoring opportunities after every "green" (TDD)
