#!/usr/bin/env fish

function glgga --wraps="git log --graph --decorate --all" --description "Alias for git log --graph --decorate --all"

    command git log --graph --decorate --all $argv

end
