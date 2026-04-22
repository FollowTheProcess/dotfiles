---
name: python
description: Use when writing, modifying, reviewing, or reading Python code — new .py files, modules, packages, or tests. Covers type hints, ruff, uv, pytest, docstrings, protocols, and modern (3.10+) idioms.
---

# Python

## Overview

Opinionated conventions for modern, typed, composable Python. Composition over inheritance. Types are mandatory, not decorative.

## When to use

- Writing or modifying any `.py` file (including tests)
- Reviewing Python code
- Designing a Python API, Protocol, or data model
- Project-level conventions in `CLAUDE.md` / `AGENTS.md` override anything here.

## Do

- **Full type hints on every signature.** Must pass `mypy` or `ty` clean.
- **Lint + format with ruff:** `ruff check` and `ruff format`. Must pass before ship.
- **Match the Python version in `pyproject.toml`.** Use modern idioms for that version (PEP 604 `X | Y` unions, `match`/`case`, PEP 695 type params where supported).
- **Use `uv` for everything:** `uv add`, `uv remove`, `uv sync`, `uv run script.py`. Don't manage venvs by hand.
- **Context managers for resources:** files, locks, connections, temp dirs. `with` or `async with`.
- **Google-style docstrings** on every public function and class.
- **Use `typing.Protocol` for interfaces** — structural, no inheritance coupling.
- **Pytest + fixtures for tests.** Prefer fixtures over setup/teardown methods.
- **`pathlib.Path` over `os.path` strings.** Join with `/`, read with `.read_text()`, etc.
- **f-strings for interpolation** — not `%` or `.format()`.
- **`X | None` over `Optional[X]`** on 3.10+.
- **Dataclasses (or `attrs` / `pydantic`) for data containers.** Don't hand-write `__init__` + `__eq__` + `__repr__`.
- **Specific exception types.** `except SomeError:` not bare `except:` or `except Exception:` unless you re-raise.
- **Early returns over deep nesting.**

## Don't

- **Don't build class hierarchies.** Compose with Protocols and plain functions. Inheritance is a last resort.
- **Don't use `os.path` string joining** for paths.
- **Don't swallow exceptions** with bare `except:` or `except Exception: pass`.
- **Don't skip types on "internal" code.** If it has a signature, it has types.
- **Don't mutate function arguments** — take input, return output.

## Quick reference

| Situation | Pattern |
|-----------|---------|
| Add a dependency | `uv add requests` |
| Add a dev dependency | `uv add --dev pytest` |
| Run a script | `uv run path/to/script.py` |
| Run tests | `uv run pytest` |
| Optional value type | `x: int \| None = None` |
| Union type | `x: int \| str` |
| File path | `Path("data") / "file.json"` |
| Read file | `Path(p).read_text()` |
| Interface | `class Store(Protocol): def get(self, k: str) -> bytes: ...` |
| Data container | `@dataclass(frozen=True, slots=True)` |
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

Any class with matching methods satisfies `Store` — no `isinstance`, no base class.

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

## Common mistakes

| Mistake | Fix |
|---------|-----|
| `pip install X` in a project | `uv add X` |
| `Optional[X]` on 3.10+ | `X \| None` |
| `os.path.join("a", "b")` | `Path("a") / "b"` |
| Bare `except:` | Catch the specific exception or re-raise |
| Missing return-type annotation | Annotate — `-> None` is valid and required |
| Subclassing for shared behaviour | Extract a function, or a Protocol + composition |
| `.format()` / `%` strings | f-strings |
| Handwritten `__init__` for data | `@dataclass` |
