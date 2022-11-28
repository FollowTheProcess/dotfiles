#!/usr/bin/env fish

function gaa --wraps="git add -A" --description "Alias for git add -A."

    command git add -A $argv

end
