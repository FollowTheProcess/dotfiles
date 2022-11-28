#!/usr/bin/env fish

function la --wraps="exa -a" --description "Wraps exa -a"

    command exa -la $argv

end
