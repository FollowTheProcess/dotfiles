#!/usr/bin/env fish

function ll --wraps="eza -l" --description "Wraps eza -l"

    command eza -l $argv

end
