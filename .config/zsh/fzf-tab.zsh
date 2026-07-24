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

# Use tmux popup if inside tmux, else inline fzf. The popup feels much nicer.
zstyle ':fzf-tab:*' fzf-command fzf

# Hide fzf's `current/total` scroll indicator in all preview panes.
zstyle ':fzf-tab:*' fzf-flags --preview-window=noinfo

# Preview pane: bat for files, eza tree for directories.
zstyle ':fzf-tab:complete:*:*' fzf-preview '
    if [[ -d $realpath ]]; then
        eza --tree --color=always --icons=auto --level=2 -- $realpath 2>/dev/null | head -200
    elif [[ -f $realpath ]]; then
        bat --color=always --style=numbers --line-range=:200 -- $realpath 2>/dev/null
    else
        echo $realpath
    fi'

# git: show commit body / diff / log in the preview pane.
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
    'git diff --color=always -- $word | delta 2>/dev/null || git diff --color=always -- $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
    'git log --color=always --oneline --graph --decorate $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
    'git help $word | bat --plain --language=help --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
    'case "$group" in
        "commit tag") git show --color=always $word ;;
        *) git show --color=always $word | delta 2>/dev/null || git show --color=always $word ;;
    esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
    'case "$group" in
        "modified file") git diff --color=always $word | delta 2>/dev/null || git diff --color=always $word ;;
        "recent commit object name") git show --color=always $word | delta 2>/dev/null || git show --color=always $word ;;
        *) git log --color=always --oneline $word ;;
    esac'

# kill / ps: show full process line in the preview.
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap:noinfo

# Environment variables: show the value.
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
    fzf-preview 'echo ${(P)word}'

# man pages: render the page itself as the preview.
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word | bat -l man -p --color=always'

# brew: show formula info.
zstyle ':fzf-tab:complete:brew-(install|uninstall|info|search|cat):*' fzf-preview \
    'brew info $word'

# systemctl: show unit status (mostly useful on Linux but harmless on macOS).
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

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
