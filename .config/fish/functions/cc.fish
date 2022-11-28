#!/usr/bin/env fish

function cc --wraps=cookiecutter --description 'alias cc=cookiecutter'
    command cookiecutter $argv
end
