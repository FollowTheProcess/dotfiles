#!/usr/bin/env fish

function go --wraps="go" --description "Wrapper around the Go command to add a new subcommand"
    if test (count $argv) -eq 2
        if test $argv[1] = new
            set_color cyan
            echo "Creating new project $argv[2]"
            set_color normal

            set -l name $argv[2]

            mkdir $name
            cd $name
            cp ~/.config/fish/functions/assets/main.go .
            command go mod init github.com/FollowTheProcess/$name
            command git init
            command git add .
            command git commit -m "Initial commit"

        end
    else
        command go $argv
    end
end
