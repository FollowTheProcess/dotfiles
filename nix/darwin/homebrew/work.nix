{
  flake.modules.darwin.work = {
    homebrew = {
      taps = [
        {
          name = "score-spec/tap";
          trusted = true;
        }
      ];
      brews = [
        "mockery"
        "score-spec/tap/score-k8s"
      ];
      casks = [
        "helium-browser"
        "tuple"
      ];
    };
  };
}
