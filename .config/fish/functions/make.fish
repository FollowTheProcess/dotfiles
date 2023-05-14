#!/usr/bin/env fish

function make --description "Wrapper around make/just."
    if [ -f justfile ] || [ -f Justfile ]
        command just $argv
    else
        command gmake $argv
    end
end
