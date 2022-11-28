#!/usr/bin/env fish

function sed --wraps=gsed --description 'alias sed=gsed'
    command gsed $argv
end
