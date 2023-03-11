#!/usr/bin/env fish

function xargs --wraps="gxargs" --description 'alias xargs=gxargs'
    command gxargs $argv
end
