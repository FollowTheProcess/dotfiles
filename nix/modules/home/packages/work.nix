# Packages for my work machine (in addition to common)
{ pkgs, ... }: {
  home.packages = with pkgs; [
    argocd
    bruno
    bruno-cli
    checkov
    fluxcd
    glab
    k6
    kubectl
    kubectx
    kustomize
    nodejs
    stern
    terragrunt
    trivy
  ];
}
