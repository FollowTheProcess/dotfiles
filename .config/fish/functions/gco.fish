#!/usr/bin/env fish

function gco --wraps="git checkout" --description "Alias for git checkout <args>."

    command git checkout $argv

end
