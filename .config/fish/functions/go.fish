#!/usr/bin/env fish

function go --wraps="go" --description "Wraps calls to go test and replaces with gotest for colour"

    if begin
            test (count $argv) -gt 0; and test $argv[1] = test
        end
        command gotest $argv[2..]
    else
        command go $argv
    end
end
