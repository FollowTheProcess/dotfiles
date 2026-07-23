{
  flake.modules.homeManager.base = _: {
    programs.fzf = {
      enable = true;

      # atuin owns Ctrl-R (sourced after fzf), so disable fzf's history widget.
      historyWidget.command = "";

      # Use fd for file/dir walks - faster, respects .gitignore.
      defaultCommand = "fd --type=f --hidden --follow --exclude .git";
      changeDirWidget.command = "fd --type=d --hidden --follow --exclude .git";
      # Ctrl-T has no command set, so fzf falls back to defaultCommand.

      # Previews: bat for files (syntax highlight), eza tree for dirs.
      fileWidget.options = [
        "--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
      ];
      changeDirWidget.options = [
        "--preview 'eza --tree --color=always --icons=auto {} | head -200'"
      ];

      # Layout. Colours are appended separately via `colors` below.
      defaultOptions = [
        "--height=40%"
        "--layout=reverse"
        "--border=rounded"
        "--info=inline"
      ];
    };
  };
}
