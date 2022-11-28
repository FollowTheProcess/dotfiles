#!/usr/bin/env fish

function ls --wraps="exa" --description "Aliasing ls to exa."

    command exa $argv

end
