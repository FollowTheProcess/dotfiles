#!/usr/bin/env fish


function pygrep -d "Greps pyenv install --list for <version>"
    argparse --min-args 0 --max-args 1 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Greps pyenv install --list for <version>"
        echo
        echo "Usage:"
        echo "  pygrep <version>"
        echo
        echo "Flags:"
        echo "  [-h/--help]: Show this help message and exit."
        echo
        return 0
    end

    pyenv install --list | rg "$argv[1]"

end
