#!/usr/bin/env fish

function make --wraps=gmake --description 'alias make=gmake'
    command gmake $argv
end
