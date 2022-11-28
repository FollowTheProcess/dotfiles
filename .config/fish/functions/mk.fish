#!/usr/bin/env fish

# Replace annoying mkdir -> cd loop
function mk -d "Replaces the annoying mkdir && cd loop."
    argparse --min-args 0 --max-args 1 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Replaces the annoying mkdir then cd loop and does it in one go!"
        echo
        echo "Usage:"
        echo "  mk <dir>"
        echo
        echo "Flags:"
        echo "  [-h/--help]: Show this help message and exit."
        echo
        return 0
    end

    set name $argv[1]

    mkdir $name
    cd $name

end
