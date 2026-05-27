---
name: python
description: Use when writing, modifying, reviewing, or reading Python code.
---

# Python

## Overview

Opinionated conventions for modern, typed, composable Python. Composition over inheritance. Types are mandatory, not decorative.

**RELATED SKILLS:** General test discipline (TDD, black-box testing, naming) lives in `tests` and `superpowers:test-driven-development`. This skill only adds Python-specific test mechanics.

## When to use

- Writing, modifying or reviewing any `.py` file (including tests)
- Designing a Python API, Protocol, or data model

## Do

- **Full type hints on every signature, internal code and tests included.** Must pass `mypy --strict` or `ty` clean.
- **Lint + format with ruff:** `ruff check` and `ruff format`. Both must pass before ship.
- **`pyproject.toml` is the source of truth** for dependencies, build, and tool config. No `setup.py`, no `requirements.txt`, no `tox.ini` for what `pyproject.toml` can hold.
- **Match the Python version in `pyproject.toml`.** Use modern idioms for that version (PEP 604 `X | Y`, `match`/`case`, PEP 695 type params, `Self`, `TaskGroup`, `StrEnum`).
- **Use `uv` for everything:** `uv add`, `uv remove`, `uv sync`, `uv run`. Don't manage venvs by hand.
- **Context managers for resources:** files, locks, connections, temp dirs. `with` or `async with`. Always pass `encoding="utf-8"` on text I/O.
- **Google-style docstrings** on every public function and class.
- **`typing.Protocol` for interfaces:** structural, no inheritance coupling.
- **Accept the most general type, return the most specific.** Params take `Iterable[T]` / `Mapping[K, V]`; returns use concrete `list[T]` / `dict[K, V]` when the caller benefits.
- **`pathlib.Path` over `os.path` strings.** Join with `/`, read with `.read_text(encoding="utf-8")`.
- **f-strings for interpolation,** not `%` or `.format()`.
- **`X | None` over `Optional[X]`** on 3.10+.
- **Dataclasses (or `attrs` / `pydantic`) for data containers.** `frozen=True, slots=True` unless you have a reason not to. Don't hand-write `__init__` + `__eq__` + `__repr__`.
- **`StrEnum` / `IntEnum` (3.11+) for fixed value sets,** not magic strings or integers.
- **Specific exception types.** `except SomeError:`, not bare `except:` or `except Exception:` unless you re-raise.
- **`logging` for diagnostics,** never `print`. Configure at the application edge; libraries get a `logging.getLogger(__name__)` and nothing else.
- **Structured concurrency** via `async with asyncio.TaskGroup() as tg: tg.create_task(...)` (3.11+) over `asyncio.gather` for collected exceptions and clean cancellation.
- **Parametrize with `pytest.mark.parametrize`** for many similar cases. Fixtures over setup/teardown.
- **Narrow with `TypeIs` (3.13+) or `TypeGuard` (3.10+)** for custom type-narrowing predicates. Reserve `typing.cast` for last resort.
- **Early returns over deep nesting.**

## Don't

- **Don't build class hierarchies.** Compose with Protocols and plain functions. Inheritance is a last resort.
- **Don't use mutable default arguments.** `def f(x: list[int] = [])` shares state across calls. Use `None` and assign in the body.
- **Don't swallow exceptions** with bare `except:` or `except Exception: pass`. Catch the specific type or re-raise.
- **Don't drive control flow with `getattr` / `hasattr`.** Stringly-typed dispatch bypasses the type checker. Use a Protocol or `match`/`case`.
- **Don't mutate function arguments.** Take input, return output.

## Rationalizations

| Excuse | Reality |
|--------|---------|
| "It's just a helper, types are overkill" | Untyped islands rot the type-check boundary. Same cost to type it now, much higher later. |
| "Bare `except` is fine, we re-raise anyway" | One missed re-raise path swallows `KeyboardInterrupt`. Name the type. |
| "Inheritance saves me duplicating that method" | Extract a function or a Protocol. Inheritance ties the contract to a class tree you'll regret. |
| "`Optional[X]` reads better" | `X \| None` is the in-language form. Mixed styles fragment the codebase. |
| "Mutable default just works for now" | Until the second call. The bug shows up far from the line that caused it. |
| "I'll add `# type: ignore` and move on" | Type ignores ossify. Fix the type, narrow the scope, or carve out a `cast`. |

## Quick reference

| Situation | Pattern |
|-----------|---------|
| Add a dependency | `uv add requests` |
| Add a dev dependency | `uv add --dev pytest` |
| Run a script | `uv run path/to/script.py` |
| Run tests | `uv run pytest` |
| Optional value | `x: int \| None = None` |
| Union | `x: int \| str` |
| Most general param type | `items: Iterable[int]` |
| File path | `Path("data") / "file.json"` |
| Read text | `Path(p).read_text(encoding="utf-8")` |
| Read TOML (stdlib) | `tomllib.loads(text)` |
| Interface | `class Store(Protocol): def get(self, k: str) -> bytes: ...` |
| Data container | `@dataclass(frozen=True, slots=True)` |
| Fixed value set | `class Color(StrEnum): RED = "red"` |
| Structured concurrency | `async with asyncio.TaskGroup() as tg:` |
| Builder return type | `def with_x(self, x: int) -> Self:` |
| Type-narrowing predicate | `def is_str(x: object) -> TypeIs[str]:` |
| Parametrized test | `@pytest.mark.parametrize("in_,want", [...])` |
| Structural match | `match shape: case Circle(r): ...` |

## Protocol pattern

```python
from typing import Protocol

class Store(Protocol):
    def get(self, key: str) -> bytes: ...
    def put(self, key: str, value: bytes) -> None: ...

def cache_result(store: Store, key: str, value: bytes) -> None:
    store.put(key, value)
```

Any class with matching methods satisfies `Store`. No `isinstance`, no base class.

## Dataclass pattern

```python
from dataclasses import dataclass
from pathlib import Path

@dataclass(frozen=True, slots=True)
class Config:
    """Runtime configuration loaded from disk.

    Attributes:
        root: Directory containing project data.
        timeout: Request timeout in seconds.
    """
    root: Path
    timeout: float = 30.0
```

`frozen=True` makes instances hashable and immutable; `slots=True` removes per-instance `__dict__` overhead.
