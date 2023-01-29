#!/usr/bin/env fish

function prune --description "Prunes all local branches that have been merged."
    argparse --min-args 0 --max-args 1 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Prunes local git branches."
        echo
        echo (set_color --bold)"Usage:"(set_color normal)
        echo "	prune"
        echo
        echo (set_color --bold)"Flags:"(set_color normal)
        echo "  [-h/--help]: Show this help message and exit."
        echo
        return 0
    end

    echo "Removing ALL local branches (other than this one... obviously)"
    git branch | grep -v '\*' | xargs git branch -D
    return 0

end
