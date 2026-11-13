{
  # cook-cli's integration tests start the `server` feature's HTTP server on an
  # ephemeral port, which the Nix sandbox denies. Unit tests still run.
  flake.overlays.cook-cli = _final: prev: {
    cook-cli = prev.cook-cli.overrideAttrs (_old: {
      cargoTestFlags = [
        "--lib"
        "--bins"
      ];
    });
  };
}
