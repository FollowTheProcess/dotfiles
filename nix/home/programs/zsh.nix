{ inputs, ... }:
{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.sessionPath = [
        "$HOME/go/bin" # go install (GOBIN)
        "$HOME/.bun/bin" # bun
        "$HOME/.local/bin" # uv, pipx, misc
        "$HOME/.cargo/bin" # cargo install
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
      ];

      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
        enableCompletion = true;
        # Runs before plugins (fzf-tab) are sourced, so completion is ready for them.
        completionInit = ''
          # Dirs compinit and history write to, created on a fresh machine.
          [[ -d $XDG_CACHE_HOME/zsh ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
          [[ -d $XDG_STATE_HOME/zsh ]] || mkdir -p "$XDG_STATE_HOME/zsh"

          # Cache the compinit security scan + dump for 24h instead of rebuilding it
          # on every launch. The daily refresh still picks up newly installed
          # completions (e.g. after a nix rebuild) without a manual dump delete.
          autoload -Uz compinit
          zmodload -F zsh/stat b:zstat
          zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
          if [[ -f $zcompdump ]] && (($(zstat +mtime "$zcompdump") > $(date +%s) - 86400)); then
              compinit -C -d "$zcompdump"
          else
              # -i ignores insecure (eg. group-writable Homebrew) dirs instead of
              # blocking startup on a y/n prompt when the cache goes stale.
              compinit -i -d "$zcompdump"
          fi
          unset zcompdump

          # complist for completion-list keybindings; fzf-tab provides the menu UI.
          zmodload zsh/complist
        '';

        # Some extra .zshrc stuff that doesn't nicely go in here
        initContent = lib.mkMerge [
          (builtins.readFile (inputs.self + "/.config/zsh/.zshrc"))
          (builtins.readFile (inputs.self + "/.config/zsh/fzf-tab.zsh"))
        ];

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
          "AUTO_PUSHD"
          "PUSHD_IGNORE_DUPS"
          "PUSHD_SILENT"
          "NO_BEEP"
          "NUMERIC_GLOB_SORT"
          "EXTENDED_GLOB"
          "INTERACTIVE_COMMENTS"
          "GLOB_DOTS"
          "MULTIOS"
          "LONG_LIST_JOBS"
          "NOTIFY"
          "NO_FLOW_CONTROL"
          "RC_QUOTES"
          "COMPLETE_IN_WORD"
          "ALWAYS_TO_END"
          "HIST_SAVE_NO_DUPS"
          "HIST_FIND_NO_DUPS"
          "HIST_REDUCE_BLANKS"
          "HIST_VERIFY"
          "INC_APPEND_HISTORY"
        ];

        sessionVariables = {
          GRANTED_ALIAS_CONFIGURED = "true";
          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
          MANROFFOPT = "-c";
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
          zed = "zeditor"; # nix/modules/home/programs/zed.nix installs zed as "zeditor"
        };

        plugins = [
          {
            name = "fzf-tab";
            src = pkgs.zsh-fzf-tab;
            file = "share/fzf-tab/fzf-tab.plugin.zsh";
          }
        ];

        autosuggestion = {
          enable = true;
          highlight = "fg=#6e738d"; # catppuccin macchiato overlay0
        };

        zsh-abbr = {
          enable = true;
          abbreviations = {
            ff = "fastfetch";
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

        # Custom functions, one per file in .config/zsh/functions, globbed.
        siteFunctions =
          let
            fnDir = inputs.self + "/.config/zsh/functions";
            entries = builtins.readDir fnDir;
            names = builtins.filter (n: entries.${n} == "regular") (builtins.attrNames entries);
          in
          lib.genAttrs names (name: builtins.readFile (fnDir + "/${name}"));
      };
    };
}
