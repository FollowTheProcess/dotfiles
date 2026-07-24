# fzf-tab configuration.
# https://github.com/Aloxaf/fzf-tab/wiki/Configuration

# Disable zsh's built-in menu completion - fzf-tab replaces it. Leaving the
# default `menu select` active causes a brief flicker on Tab.
zstyle ':completion:*' menu no

# home-manager sources `fzf --zsh` after the fzf-tab plugin, and fzf's
# integration rebinds Tab to its own `fzf-completion`. Reclaim Tab for fzf-tab.
enable-fzf-tab

# Switch between completion groups with `<` and `>` (eg. files vs branches).
zstyle ':fzf-tab:*' switch-group '<' '>'

# Continuous trigger: keep refining the candidate list as you type instead of
# requiring a fresh Tab press.
zstyle ':fzf-tab:*' continuous-trigger 'tab'

zstyle ':fzf-tab:*' query-string prefix

# Use tmux popup if inside tmux, else inline fzf. The popup feels much nicer.
zstyle ':fzf-tab:*' fzf-command fzf

# Pass $FZF_DEFAULT_OPTS through to the tab popup.
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Hide fzf's `current/total` scroll indicator in all preview panes.
zstyle ':fzf-tab:*' fzf-flags --preview-window=noinfo

# Preview pane: bat for files, eza tree for directories.
zstyle ':fzf-tab:complete:*:*' fzf-preview '
    local target=${realpath:-$word}
    target=${target/#\~/$HOME}
    target=${target%% }
    if [[ -d $target ]]; then
        eza --tree --color=always --icons=auto --level=2 -- $target 2>/dev/null | head -200
    elif [[ -f $target ]]; then
        bat --paging=never --color=always --style=numbers --line-range=:200 -- $target 2>/dev/null
    else
        echo "$target"
    fi'

# Environment variables: show the value.
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
    fzf-preview 'echo ${(P)word}'

# man pages: render the page itself as the preview.
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word | bat -l man -pp --color=always'

# gig: multi-select gitignore templates (Tab toggles, Enter inserts all).
# No preview - template names aren't files, so the default file preview is noise.
zstyle ':fzf-tab:complete:gig:*' fzf-flags --multi --no-preview

# go: show `go help <cmd...>` in the preview. Works for any
# subcommand depth (`go mod tidy`, `go help mod tidy`, ...).
zstyle ':fzf-tab:complete:(go|go-*):*' fzf-preview '
    local -a chain=(${words[2,-2]})
    local idx=${chain[(i)-*]}
    (( idx <= ${#chain} )) && chain=(${chain[1,idx-1]})
    [[ ${chain[1]:-} == help ]] && chain=(${chain[2,-1]})
    local target=${word% }
    [[ $target == -* ]] && target=
    local out
    out=$(go help ${chain[@]} $target 2>/dev/null)
    if [[ -n $out ]]; then
        printf "%s\n" "$out" | bat --plain --language=help --color=always 2>/dev/null \
            || printf "%s\n" "$out"
    else
        echo "no help: go help ${chain[*]} $target"
    fi
'
