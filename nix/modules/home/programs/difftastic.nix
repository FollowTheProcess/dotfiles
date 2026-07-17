{ ... }: {
  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
      mode = "external";
    };
    jujutsu = {
      enable = true;
    };
    options = {
      color = "always";
      sort-paths = true;
      tab-width = 4;
    };
  };
}
