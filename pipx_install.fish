#!/usr/bin/env fish

pipx ensurepath

for package in build codespell copier datamodel-code-generator httpie mypy nox pdm poetry pre-commit ruff tbump uv virtualenv
    pipx install $package
end
