#!/usr/bin/env fish

function gsc --wraps="git switch --create" --description "Alias for git switch --create <args>."

    command git switch --create $argv

end
