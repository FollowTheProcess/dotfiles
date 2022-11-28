#!/usr/bin/env fish

function prune --description "Prunes all local branches that have been merged."
    argparse --min-args 0 --max-args 1 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Prunes all local branches that have been merged"
        echo
        echo (set_color --bold)"Usage:"(set_color normal)
        echo "	prune"
        echo
        echo (set_color --bold)"Flags:"(set_color normal)
        echo "	[-h/--help]: Show this help message and exit."
        echo
        return 0
    end
    # Function body goes here
    git branch --merged | grep -v '\*' | xargs git branch -d

end
