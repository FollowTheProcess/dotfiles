# Aliases that replace built-in tools with better alternatives. These need to
# be real aliases (not abbreviations) so they apply inside scripts, command
# substitutions, and one-liners without thinking about expansion.
#
# Short-hand abbreviations (gs, k, tf, build, etc.) live in `abbreviations` -
# those expand visibly so history records the full command.

# https://docs.commonfate.io/granted/internals/shell-alias
alias assume="source $HOMEBREW_PREFIX/bin/assume"

alias cat='bat --paging=never'                                           # Use https://github.com/sharkdp/bat instead of cat
alias find='gfind'                                                       # Use GNU find
alias make='gmake'                                                       # Use GNU make
alias sed='gsed'                                                         # Use GNU sed
alias ls='eza --icons=auto --group-directories-first'                    # Use https://github.com/eza-community/eza instead of ls
alias ll='eza --icons=auto --group-directories-first --long --git'       # Long listing with git status
alias la='eza --icons=auto --group-directories-first --long --git --all' # Long listing including hidden
alias tree='eza --tree --icons=auto'                                     # Use https://github.com/eza-community/eza instead of tree
alias du='dust'                                                          # Use https://github.com/bootandy/dust instead of du
alias ps='procs'                                                         # Use https://github.com/dalance/procs instead of ps
alias xargs='gxargs'                                                     # Use GNU xargs
alias tar='gtar'                                                         # Use GNU tar
