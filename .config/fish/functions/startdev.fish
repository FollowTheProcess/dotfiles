#!/usr/bin/env fish

function startdev --description "Executes the junkshon startdev script in zsh, and opens chrome at localhost:8000"
    argparse --min-args 0 --max-args 0 h/help c/chrome -- $argv
    or return 1

    if set -q _flag_help
        echo "Executes the junkshon startdev script in zsh, and opens chrome at localhost:8000"
        echo
        echo "After you've started, your python logs will appear in the terminal window as normal."
        echo "To kill the process you can hit any key to get out of the log then ctrl+c"
        echo "or simply kill the terminal session."
        echo
        echo "Usage:"
        echo "	startdev"
        echo
        echo "Flags:"
        echo "  [-h/--help]: Show this help message and exit."
        echo "  [-c/--chrome]: Also open chrome."
        echo
        echo
        return 0
    end
    # Function body goes here
    set_color green
    echo "Starting up platform in the background"
    set_color normal
    echo "Note: This function will always select option 1) Local Dev"
    echo
    echo 1 | zsh "startdev.sh" 2>&1 >/dev/null &
    if set -q _flag_chrome
        set_color yellow
        echo "Waiting for a few seconds, then I'll open Google Chrome for you!"
        set_color normal
        sleep 5
        open -a "Google Chrome" "http://localhost:8000/"
    end
    trap 'jobs -p | xargs kill' SIGINT SIGTERM EXIT

end
