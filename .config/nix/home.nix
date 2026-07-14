# Home Manager config
# https://nix-community.github.io/home-manager/options/home-manager/index.html

{ config, pkgs, ...}:

{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.11";

  # User packages
  home.packages = [
    pkgs.nil # Nix LSP
    pkgs.nixd # Another nix LSP
  ];

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
