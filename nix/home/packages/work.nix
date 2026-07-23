# Packages for my work machine (in addition to base)
{
  flake.modules.homeManager.work = { pkgs, ... }: {
    home.packages = with pkgs; [
      argocd
      bruno
      bruno-cli
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
  };
}
