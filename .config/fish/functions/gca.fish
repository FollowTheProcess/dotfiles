#!/usr/bin/env fish

function gca --wraps="git commit -a -m" --description "Alias for git commit -a -m <arg>"

    command git add -A && command git commit -m $argv

end
