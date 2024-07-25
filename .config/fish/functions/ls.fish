#!/usr/bin/env fish

function ls --wraps="eza" --description "Aliasing ls to eza."

    command eza $argv

end
