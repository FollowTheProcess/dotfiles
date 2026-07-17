{ pkgs, ... }:
let
  # to update: nurl https://github.com/catppuccin/starship
  catppuccin-starship = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "starship";
    rev = "5906cc369dd8207e063c0e6e2d27bd0c0b567cb8";
    hash = "sha256-FLHjbClpTqaK4n2qmepCPkb8rocaAo3qeV4Zp1hia0g=";
  };
  # themes/macchiato.toml is just the [palettes.catppuccin_macchiato] table
  macchiato = fromTOML (builtins.readFile "${catppuccin-starship}/themes/macchiato.toml");
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      palette = "catppuccin_macchiato";

      username.disabled = true;

      directory = {
        read_only = " 󰌾";
        style = "bold sky";
        substitutions = {
          "dotfiles" = "󰋜 dotfiles";
          "Development" = " dev";
        };
      };

      git_branch = {
        symbol = " ";
        style = "bold mauve";
      };

      aws = {
        disabled = false;
        symbol = "  ";
        style = "bold peach";
      };

      status = {
        disabled = false;
        symbol = "✖ ";
        map_symbol = true; # shows SIGINT etc. as names
      };

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };

      python = {
        style = "bold yellow";
        symbol = " ";
      };

      golang = {
        style = "bold sapphire";
        symbol = " ";
      };

      nodejs = {
        style = "bold green";
        symbol = " ";
      };

      bun = {
        style = "bold pink";
        symbol = " ";
      };

      swift = {
        style = "bold teal";
        symbol = "󰛥 ";
      };

      nix_shell = {
        style = "bold teal";
        symbol = " ";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        conflicted = "󰘭 \${count}";
        ahead = "↑ \${count}";
        behind = "↓ \${count}";
        diverged = "↕↑ \${ahead_count}↓\${behind_count}";
        untracked = "󰋗 \${count}";
        stashed = "󰏋 \${count}";
        modified = "󰏫 \${count}";
        staged = "󰐗 \${count}";
        renamed = "󰓡 \${count}";
        deleted = "󰩺 \${count}";
        style = "bold peach";
      };

      git_commit = {
        tag_disabled = false;
        only_detached = false;
        tag_max_candidates = 1;
        style = "bold green";
      };

      docker_context = {
        style = "bold blue";
        symbol = " ";
      };

      kubernetes = {
        disabled = false;
        detect_env_vars = [ "SHOW_STARSHIP_K8S_CONTEXT" ];
        style = "bold blue";
      };

      git_state = {
        style = "bold peach";
      };

      cmd_duration = {
        style = "bold yellow";
      };

      terraform = {
        symbol = "󱁢 ";
        style = "bold lavender";
      };

      # custom module for jj status
      # https://github.com/jj-vcs/jj/wiki/Starship#alternative-prompt
      custom.jj = {
        description = "The current jj status";
        when = "while ! test -d .jj; do test $PWD = / && exit 1; cd -P ..; done; exit 0";
        shell = [ "sh" "--norc" "--noprofile" ];
        symbol = "🥋 ";
        require_repo = true;
        command = ''
          jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
            separate(" ",
              change_id.shortest(4),
              bookmarks,
              "|",
              concat(
                if(conflict, "💥"),
                if(divergent, "🚧"),
                if(hidden, "👻"),
                if(immutable, "🔒"),
              ),
              raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
              raw_escape_sequence("\x1b[1;32m") ++ coalesce(
                truncate_end(29, description.first_line(), "…"),
                "(no description set)",
              ) ++ raw_escape_sequence("\x1b[0m"),
            )
          '
        '';
      };

      # palette table pulled from catppuccin/starship
      inherit (macchiato) palettes;
    };
  };
}
