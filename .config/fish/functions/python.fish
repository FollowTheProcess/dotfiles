#!/usr/bin/env fish

function python --wraps="uv run" --description "Run uv managed python"

    command uv run python $argv

end
