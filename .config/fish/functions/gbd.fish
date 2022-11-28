#!/usr/bin/env fish

function gbd --wraps="git branch -D" --description "Force delete a git branch by name."

    command git branch -D $argv

end
