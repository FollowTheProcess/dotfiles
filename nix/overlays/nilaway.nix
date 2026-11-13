{
  # nilaway tests fail on Go 1.27 because they call `go list` at runtime
  # which fails to find packages
  flake.overlays.nilaway = _final: prev: {
    nilaway = prev.nilaway.overrideAttrs (_old: {
      doCheck = false;
    });
  };
}
