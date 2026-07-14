# home.nix
#
# Run `home-manager switch` to apply

{ config, pkgs, ...}:

{
  home.username = "tomfleet";
  home.homeDirectory = "/Users/tomfleet";

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
  ];

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
