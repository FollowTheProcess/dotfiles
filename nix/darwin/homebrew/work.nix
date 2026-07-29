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
        "score-spec/tap/score-k8s"
      ];
      casks = [
        "helium-browser"
        "tuple"
      ];
    };
  };
}
