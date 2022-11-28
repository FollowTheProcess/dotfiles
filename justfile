timestamp := `date +"%Y-%m-%d %H:%M:%S"`
fish_dir := "~/.config/fish/"

# By default just print a list of recipes
_default:
    @just --list

# Commit and push current state to GitHub
sync:
    git add -A
    git commit -m "Sync: {{ timestamp }}"
    git push

# Installs fish functions
functions:
    rm -rf ~/.config/fish/functions/
    cp -r .config/fish/functions {{ fish_dir }}

# Installs fish completions
completions:
    cp -r .config/fish/completions {{ fish_dir }}

# Installs fish config
config:
    cp -r .config/fish/config.fish {{ fish_dir }}

# Does all the fish things
fish: functions completions config
