# Python

## Do

- All signatures must have complete type hints and pass a type checker like `mypy` or `ty`
- All code must pass linting with `ruff check` and be formatted with `ruff format`
- Use modern python idioms matching the Python version constraints in `pyproject.toml`
- Use context managers for resource handling
- Document all functions and classes with descriptive docstrings following the Google docstring style
- Use `uv` for all package management and virtual environment related tasks
- Use `typing.Protocol` for defining interfaces rather than asbtract base classes etc.
- Use `pytest` and pytest fixtures for testing

## Don't

- Generate class hierarchies, prefer composition over inheritance
