{ pkgs, ... }:
let
  catppuccin-btop = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "f437574b600f1c6d932627050b15ff5153b58fa3";
    hash = "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";
  };
in
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_macchiato";
      theme_background = false;
    };
    themes = {
      catppuccin_macchiato = builtins.readFile "${catppuccin-btop}/themes/catppuccin_macchiato.theme";
    };
  };
}
