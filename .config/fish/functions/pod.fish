#!/usr/bin/env fish

function pod --description "Create a new POD ticket."
    argparse --min-args 0 --max-args 0 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Create a new POD ticket"
        echo
        echo (set_color --bold)"Usage:"(set_color normal)
        echo "	pod"
        echo
        echo (set_color --bold)"Flags:"(set_color normal)
        echo "	[-h/--help]: Show this help message and exit."
        echo
        return 0
    end
    # Function body goes here
    set TYPE (gum choose --header "Type of branch?" "feature" "fix" "ci" "chore" "docs" "refactor" "deps" "release")
    set TICKET (gum input --placeholder "Jira ticket number")

    command git switch --create $TYPE/$TICKET

end
