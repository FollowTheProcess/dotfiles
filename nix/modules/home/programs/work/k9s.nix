{ pkgs, ... }:
let
  # to update: nurl https://github.com/catppuccin/k9s
  catppuccin-k9s = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "k9s";
    rev = "fdbec82284744a1fc2eb3e2d24cb92ef87ffb8b4";
    hash = "sha256-9h+jyEO4w0OnzeEKQXJbg9dvvWGZYQAO4MbgDn6QRzM=";
  };
in
{
  programs.k9s = {
    enable = true;
    settings = {
      ui = {
        logoless = true;
        skin = "catppuccin-macchiato-transparent";
      };
    };
    skins = {
      catppuccin-macchiato-transparent = "${catppuccin-k9s}/dist/catppuccin-macchiato-transparent.yaml";
    };
    aliases = {
      dp = "deployments";
      sec = "v1/secrets";
      jo = "jobs";
      cr = "clusterroles";
      crb = "clusterrolebindings";
      ro = "roles";
      rb = "rolebindings";
      np = "networkpolicies";
    };
  };
}
