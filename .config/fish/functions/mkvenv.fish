#!/usr/bin/env fish

function mkvenv --description "Makes a python virtual environment and updates seeds.."
    argparse --min-args 0 --max-args 0 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Makes a python virtual environment and updates seeds."
        echo
        echo (set_color --bold)"Usage:"(set_color normal)
        echo "	mkvenv"
        echo
        echo (set_color --bold)"Flags:"(set_color normal)
        echo "	[-h/--help]: Show this help message and exit."
        echo
        return 0
    end
    # Function body goes here
    py -m venv .venv
    py -m pip install --upgrade pip setuptools wheel

end
