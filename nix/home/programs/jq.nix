{
  flake.modules.homeManager.base = _: {
    # There is no official Catppuccin port for jq, so this is a best effort
    programs.jq = {
      enable = true;
      colors = {
        null = "0;38;2;128;135;162"; # Overlay1 #8087a2 (muted: absence of value)
        false = "0;38;2;198;160;246"; # Mauve    #c6a0f6 (keyword)
        true = "0;38;2;198;160;246"; # Mauve    #c6a0f6 (keyword)
        numbers = "0;38;2;245;169;127"; # Peach    #f5a97f
        strings = "0;38;2;166;218;149"; # Green    #a6da95
        arrays = "0;38;2;147;154;183"; # Overlay2 #939ab7 (structural)
        objects = "0;38;2;147;154;183"; # Overlay2 #939ab7 (structural)
        objectKeys = "1;38;2;138;173;244"; # Blue     #8aadf4 (bold)
      };
    };
  };
}
