_: {
  homebrew = {
    taps = [
      {
        name = "score-spec/tap";
        trusted = true;
      }
    ];
    brews = [
      "mockery"
      "score-k8s"
    ];
    casks = [
      "helium-browser"
      "tuple"
    ];
  };
}
