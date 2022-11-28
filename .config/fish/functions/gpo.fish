#!/usr/bin/env fish

function gpo --wraps="git push origin" --description "Alias for git push origin <args>"

    command git push origin $argv

end
