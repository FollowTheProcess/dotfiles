#!/usr/bin/env fish

function gst --wraps="git status" --description "Alias for git status."

    command git status $argv

end
