{ config, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    fastSyntaxHighlighting.enable = true;
    envExtra     = builtins.readFile ../../../../.config/zsh/.zshenv;
    profileExtra = builtins.readFile ../../../../.config/zsh/.zprofile;
    initContent  = builtins.readFile ../../../../.config/zsh/.zshrc;
  };
}
