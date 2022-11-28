#!/usr/bin/env fish

function bump --wraps=bump2version --description 'alias bump=bump2version'
    command bump2version $argv
end
