#!/usr/bin/env fish

function cat --wraps="bat" --description "Aliasing builtin cat to bat."

    command bat --paging=never $argv

end
