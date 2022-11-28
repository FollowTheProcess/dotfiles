#!/usr/bin/env fish

function chop --argument port
    argparse --min-args 0 --max-args 1 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Kill any processes currently running on port <port>"
        echo
        echo "If nothing is running on <port> it will simply exit"
        echo "with a success code."
        echo
        echo "If it finds something running on <port>, it will"
        echo "kill it and show you what's been killed."
        echo
        echo "If it could not kill the process for whatever reason"
        echo "it will not do anything and simply report failure."
        echo
        echo "Usage:"
        echo "  chop <port>"
        echo
        echo "Flags:"
        echo "  [-h/--help]: Show this help message and exit."
        echo
        return 0
    end

    set n_args (count $argv)

    switch $n_args

        case 0
            set_color red
            echo "chop expected an argument: port"
            set_color normal
            return 1

        case 1
            for pid in (lsof -i TCP:$port | awk '/LISTEN/{print $2}')
                echo -n "Found server for port $port with pid $pid: "
                kill -9 $pid; and echo "killed."; or echo "could not kill."
            end
        case "*"
            set_color red
            echo "Unrecognised argument(s): $argv"
            set_color normal
            return 1
    end
end
