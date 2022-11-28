#!/usr/bin/env fish

function ll --wraps="exa -l" --description "Wraps exa -l"

    command exa -l $argv

end
