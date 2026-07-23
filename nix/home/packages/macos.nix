# Packages that, while distributed on nixpkgs, really only apply to macOS hosts.
{
  flake.modules.homeManager.macos = { pkgs, ... }: {
    home.packages = with pkgs; [
      container # Apple's container runtime
      ghostty-bin # Pre-built Ghostty, pkgs.ghostty doesn't work on macOS (yet)
    ];
  };
}
