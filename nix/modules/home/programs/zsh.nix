{ config, dotfiles, pkgs, ... }: {
  # Extra bin dirs prepended to PATH. nix-darwin re-prepends the nix profile
  # paths afterwards (in /etc/zshrc), so a nix tool still wins over a same-named
  # tool here. Covers imperatively-installed tools (cargo/go/bun/uv) and the
  # Homebrew CLIs (claude, freeze, gup) that nix doesn't provide.
  home.sessionPath = [
    "$HOME/go/bin"     # go install (GOBIN)
    "$HOME/.bun/bin"   # bun
    "$HOME/.local/bin" # uv, pipx, misc
    "$HOME/.cargo/bin" # cargo install
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    # -u skips compinit's insecure-directory check (e.g. group-writable
    # /opt/homebrew/share) so it never prompts on startup.
    completionInit = "autoload -U compinit && compinit -u";
    envExtra = builtins.readFile (dotfiles + "/.config/zsh/.zshenv");
    initContent = builtins.readFile (dotfiles + "/.config/zsh/.zshrc");

    history = {
      path = "${config.xdg.stateHome}/zsh/history";
      size = 10000;
      save = 10000;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
      append = true;
    };

    autocd = true;

    setOptions = [
      "AUTO_PUSHD" "PUSHD_IGNORE_DUPS" "PUSHD_SILENT" "NO_BEEP"
      "NUMERIC_GLOB_SORT" "EXTENDED_GLOB" "INTERACTIVE_COMMENTS"
      "GLOB_DOTS" "MULTIOS" "LONG_LIST_JOBS" "NOTIFY" "NO_FLOW_CONTROL"
      "RC_QUOTES" "COMPLETE_IN_WORD" "ALWAYS_TO_END"
      "HIST_SAVE_NO_DUPS" "HIST_FIND_NO_DUPS" "HIST_REDUCE_BLANKS"
      "HIST_VERIFY" "INC_APPEND_HISTORY"
    ];

    sessionVariables = {
      EDITOR = "zed --wait";
      VISUAL = "zed --wait";
      GRANTED_ALIAS_CONFIGURED = "true";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      GPG_TTY = "$TTY";
      PIP_REQUIRE_VIRTUALENV = "true";
      PYTHONUTF8 = "1";
      VIRTUALENV_PROMPT = ".venv";
      GOPATH = "$HOME/go";
      GOBIN = "$HOME/go/bin";
      GO111MODULE = "on";
      CGO_ENABLED = "0";
      GOEXPERIMENT = "jsonv2";
      CARGO_HOME = "$HOME/.cargo";
      KUBECTL_EXTERNAL_DIFF = "difft --exit-code";
      CARAPACE_BRIDGES = "zsh";
    };

    shellAliases = {
      assume = "source ${pkgs.granted}/bin/assume";
      cat = "bat --paging=never";
      find = "gfind";
      make = "gmake";
      sed = "gsed";
      ls = "eza --icons=auto --group-directories-first";
      ll = "eza --icons=auto --group-directories-first --long --git";
      la = "eza --icons=auto --group-directories-first --long --git --all";
      tree = "eza --tree --icons=auto";
      du = "dust";
      ps = "procs";
      xargs = "gxargs";
      tar = "gtar";
    };

    autosuggestion = {
      enable = true;
      highlight = "fg=#6e738d";  # catppuccin macchiato overlay0
    };

    fastSyntaxHighlighting = {
      enable = true;
      # Nix evaluates config.xdg.configHome to /Users/tomfleet/.config at build time
      theme = "${config.xdg.configHome}/zsh/catppuccin-macchiato.ini";
    };

    zsh-abbr = {
      enable = true;
      abbreviations = {
        gs = "git switch";
        gsc = "git switch --create";
        gaa = "git add --all";
        gpu = "git push";
        gl = "git log --oneline";
        gcm = "git commit -m";
        tf = "terraform";
        tg = "terragrunt";
        k = "kubectl";
        build = "pyproject-build --installer=uv";
        ts = "tree-sitter";
      };
    };
  };
}
