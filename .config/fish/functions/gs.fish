#!/usr/bin/env fish

function gs --wraps="git switch" --description "Alias for git switch <args>"

    command git switch $argv

end
