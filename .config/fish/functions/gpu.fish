#!/usr/bin/env fish

function gpu --wraps="git push" --description "Alias for git push"

    command git push $argv

end
