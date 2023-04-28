#!/usr/bin/env fish

function tree --wraps="erd" --description "Alias tree to erdtree because it's nicer"

    command erd $argv

end
