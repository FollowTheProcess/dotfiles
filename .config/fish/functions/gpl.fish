#!/usr/bin/env fish

function gpl --wraps="git pull" --description "Alias for git pull"

    command git pull $argv

end
