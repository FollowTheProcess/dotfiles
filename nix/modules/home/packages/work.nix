# Packages for my work machine (in addition to common)
{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
  ];
}
