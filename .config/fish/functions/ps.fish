#!/usr/bin/env fish

function ps --wraps="procs" --description "Aliasing ps to procs."

    command procs --pager disable $argv

end
