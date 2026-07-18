# Packages for my personal mac (in addition to common)
{ pkgs, ... }: {
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
    mdbook
    mdbook-admonish
    syft
    usage
    vhs
    zig
    zls
  ];
}
