#!/usr/bin/env fish

# Updates locate db index for fast file finding
function updatedb -d "Updates locate database index."
    argparse --min-args 0 --max-args 0 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Updates db index for 'locate' command."
        echo
        echo "Usage:"
        echo "  updatedb"
        echo
        echo "Flags:"
        echo "  [-h/--help]: Show this help message and exit."
        echo
        return 0
    end

    set_color cyan
    echo "Updating locate database..."
    set_color normal
    sudo /usr/libexec/locate.updatedb
end
