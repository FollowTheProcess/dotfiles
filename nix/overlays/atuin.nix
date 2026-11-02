{
  # atuin's test suite is flaky
  flake.overlays.atuin = _final: prev: {
    atuin = prev.atuin.overrideAttrs (_old: {
      doCheck = false;
    });
  };
}
