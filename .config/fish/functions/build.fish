#!/usr/bin/env fish

function build --wraps=pyproject-build --description 'alias build=pyproject-build'
    command pyproject-build $argv
end
