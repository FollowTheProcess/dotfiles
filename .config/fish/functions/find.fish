#!/usr/bin/env fish

function find --wraps="gfind" --description 'alias find=gfind'
    command gfind $argv
end
