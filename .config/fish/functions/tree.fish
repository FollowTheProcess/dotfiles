#!/usr/bin/env fish

function tree --wraps="tree -C" --description "Alias tree to tree -C to show colour always."

    command tree -C $argv

end
