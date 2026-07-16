{ ... }: {
  programs = {
    home-manager.enable = true;
    atuin.enable = true;
    direnv.enable = true;
    starship.enable = true;
    eza = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd" "cd" ];
    };
    fzf = {
      enable = true;
      historyWidget.command = "";
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      fastSyntaxHighlighting.enable = true;
    };
  };
}
