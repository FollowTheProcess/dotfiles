# Packages for my personal mac (in addition to base)
{ inputs, ... }: {
  flake.modules.homeManager.onyx = { pkgs, ... }: {
    home.packages = with pkgs; [
      (fenix.stable.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      actionlint
      cargo-nextest
      cook-cli
      cosign
      fenix.rust-analyzer
      glow
      hugo
      inputs.tg.packages.${pkgs.system}.default
      mdbook
      mdbook-admonish
      syft
      usage
      vhs
      zig
      zls
    ];
  };
}
