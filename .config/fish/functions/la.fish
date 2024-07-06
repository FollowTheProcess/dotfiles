#!/usr/bin/env fish

function la --wraps="eza -a" --description "Wraps eza -a"

    command eza -la $argv

end
