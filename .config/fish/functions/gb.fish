#!/usr/bin/env fish

function gb --wraps="git branch -vv" --description "Alias for git branch -vv"

    command git branch -vv $argv

end
