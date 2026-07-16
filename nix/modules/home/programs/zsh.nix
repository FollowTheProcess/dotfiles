{ config, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    # -u skips compinit's insecure-directory check (e.g. group-writable
    # /opt/homebrew/share) so it never prompts on startup.
    completionInit = "autoload -U compinit && compinit -u";
    autosuggestion.enable = true;
    fastSyntaxHighlighting.enable = true;
    envExtra = builtins.readFile ../../../../.config/zsh/.zshenv;
    profileExtra = builtins.readFile ../../../../.config/zsh/.zprofile;
    initContent = builtins.readFile ../../../../.config/zsh/.zshrc;
  };
}
