{
  config,
  lib,
  inputs,
  pkgs,
  host,
  ...
}:
let
  # Zed has no $LINE_COMMENT placeholder, so generate a per-language TODO snippet
  lineComment = {
    go = "//";
    hcl = "#";
    nix = "#";
    python = "#";
    rust = "//";
    "shell script" = "#";
    terraform = "#";
    toml = "#";
    yaml = "#";
    zig = "//";
  };
  todoSnippet =
    token:
    builtins.toJSON {
      todo = {
        prefix = "todo";
        description = "Add a TODO line comment";
        body = "${token} TODO: $0";
      };
    };
in
{
  xdg.configFile = lib.mapAttrs' (
    lang: token: lib.nameValuePair "zed/snippets/${lang}.json" { text = todoSnippet token; }
  ) lineComment;

  programs.zed-editor = {
    enable = true;
    defaultEditor = true;
    extensions = [
      "catppuccin"
      "catppuccin-icons"
      "comment"
      "cooklang"
      "dockerfile"
      "git-firefly"
      "github-actions"
      "golangci-lint"
      "html"
      "http"
      "make"
      "nix"
      "terraform"
      "tombi"
      "toml"
      "txtar"
      "xml"
      "zig"
    ];
    extraPackages = with pkgs; [
      (fenix.stable.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      docker-language-server
      go
      gofumpt
      golangci-lint
      golangci-lint-langserver
      gomodifytags
      gopls
      hadolint
      nil
      nixd
      ruff
      shellcheck
      terraform
      terraform-ls
      tombi
      ty
      uv
      yamlfmt
    ];
    themes = {
      "catppuccin-no-italics-mauve" = "${inputs.catppuccin-zed}/themes/catppuccin-no-italics-mauve.json";
    };
    userKeymaps = [
      {
        context = "Workspace || Editor";
        bindings = {
          cmd-ctrl-left = [
            "workspace::MoveItemToPaneInDirection"
            { direction = "left"; }
          ];
          cmd-ctrl-right = [
            "workspace::MoveItemToPaneInDirection"
            { direction = "right"; }
          ];
        };
      }
      {
        bindings = {
          # Swap settings file and settings UI
          "cmd-," = "zed::OpenSettingsFile";
          "cmd-alt-," = "zed::OpenSettings";
        };
      }
    ];
    userTasks = [
      {
        label = "Go: Add Struct Tags";
        command = "gomodifytags";
        args = [
          "-file"
          "$ZED_FILE"
          "-struct"
          "$ZED_SYMBOL"
          "-add-tags"
          "json"
          "-transform"
          "camelcase"
          "-skip-unexported"
          "-quiet"
          "-w"
        ];
        reveal = "never";
        hide = "always";
        shell = {
          with_arguments = {
            program = "sh";
            args = [
              "--noediting"
              "--norc"
              "--noprofile"
            ];
          };
        };
      }
      {
        label = "Go: Remove Struct Tags";
        command = "gomodifytags";
        args = [
          "-file"
          "$ZED_FILE"
          "-struct"
          "$ZED_SYMBOL"
          "-remove-tags"
          "json"
          "-quiet"
          "-w"
        ];
        reveal = "never";
        hide = "always";
        shell = {
          with_arguments = {
            program = "sh";
            args = [
              "--noediting"
              "--norc"
              "--noprofile"
            ];
          };
        };
      }
    ];
    userSettings = {
      cli_default_open_behavior = "new_window";
      collaboration_panel = {
        dock = "left";
      };
      format_on_save = "on";
      agent = {
        dock = "right";
        favorite_models = [ ];
        model_parameters = [ ];
      };
      git_panel = {
        dock = "left";
      };
      auto_signature_help = true;
      autosave = "on_focus_change";
      base_keymap = "VSCode";
      buffer_font_family = "GeistMono Nerd Font";
      buffer_font_size = 12.5;
      buffer_line_height = "comfortable";
      colorize_brackets = false;
      completions = {
        lsp = true;
        lsp_fetch_timeout_ms = 1000;
      };
      current_line_highlight = "none";
      cursor_blink = true;
      cursor_shape = "bar";
      diagnostics = {
        include_warnings = true;
        inline = {
          enabled = true;
          min_column = 80;
          update_debounce_ms = 150;
        };
      };
      disable_ai = true;
      "experimental.theme_overrides" = {
        syntax = {
          string = {
            color = "#a1e7f2ef";
          };
        };
      };
      file_scan_exclusions = [
        "**/.git"
        "**/.svn"
        "**/.hg"
        "**/.jj"
        "**/CVS"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.classpath"
        "**/.settings"
        "**/__pycache__"
        "**/.mypy_cache"
        "**/.ruff_cache"
        "**/.pytest_cache"
        "**/.rumdl-cache"
        "**/.venv"
        "**/venv"
        "**/.task"
      ];
      file_types = {
        "Cooklang" = [
          "*.cook"
          "*.menu"
        ];
        "dockerbake" = [ "docker-bake.hcl" ];
        "Git Attributes" = [ "{git,.git,.git/info}/attributes" ];
        "Git Config" = [
          "{git,.git/modules,.git/modules/*}/config"
          "**/.config/git/config"
        ];
        "Git Ignore" = [
          "{git,.git}/ignore"
          ".git/info/exclude"
          "**/.config/git/ignore"
        ];
        "GitHub Actions" = [
          ".github/workflows/*.yml"
          ".github/workflows/*.yaml"
        ];
        "json" = [
          "*.sarif"
          "*.json"
        ];
        "JSONC" = [
          "**/.zed/**/*.json"
          "**/zed/**/*.json"
          "**/Zed/**/*.json"
          "**/.vscode/**/*.json"
          "**/.devcontainer/devcontainer.json"
          "*.json5"
        ];
        "markdown" = [ "*.slide" ];
        "pip-requirements" = [
          "requirements*.in"
          "requirements*.txt"
        ];
        "ruby" = [
          ".Brewfile"
          "Brewfile"
        ];
        "Shell Script" = [
          ".env.*"
          "**/.config/zsh/functions/*"
        ];
        "terraform-tests" = [ "*.tftest.hcl" ];
        "terraform-vars" = [
          "*.tfbackend"
          "*.tfvars"
        ];
        "TOML" = [
          "*.toml"
          "**/staticcheck.conf"
        ];
        "XML" = [
          "*.plist"
          "*.xml"
        ];
        "YAML" = [
          "*.yaml"
          "*.yml"
          "*.snap"
          ".yamlfmt"
        ];
      };
      git = {
        blame = {
          show_avatar = true;
        };
        inline_blame = {
          delay_ms = 1000;
          enabled = true;
        };
      };
      icon_theme = "Catppuccin Macchiato";
      inlay_hints = {
        enabled = false;
      };
      languages = {
        "Go" = {
          language_servers = [
            "gopls"
            "golangci-lint"
          ];
        };
        "Python" = {
          formatter = [
            {
              code_action = "source.fixAll.ruff";
            }
            {
              code_action = "source.organizeImports.ruff";
            }
            {
              language_server = {
                name = "ruff";
              };
            }
          ];
          language_servers = [
            "ruff"
            "ty"
            "!pyright"
          ];
        };
        "GitHub Actions" = {
          tab_size = 2;
          formatter = {
            external = {
              command = "yamlfmt";
              arguments = [ "-" ];
            };
          };
        };
        "YAML" = {
          tab_size = 2;
          formatter = {
            external = {
              command = "yamlfmt";
              arguments = [ "-" ];
            };
          };
        };
        "TOML" = {
          tab_size = 2;
          formatter = {
            language_server = {
              name = "tombi";
            };
          };
        };
        "Nix" = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          semantic_tokens = "off";
        };
      };
      linked_edits = true;
      lsp = {
        nixd = {
          settings = {
            nixpkgs = {
              expr = ''import (builtins.getFlake "${config.home.homeDirectory}/dotfiles").inputs.nixpkgs { }'';
            };
            options = {
              nix-darwin = {
                expr = ''(builtins.getFlake "${config.home.homeDirectory}/dotfiles").darwinConfigurations.${host}.options'';
              };
              home-manager = {
                expr = ''(builtins.getFlake "${config.home.homeDirectory}/dotfiles").darwinConfigurations.${host}.options.home-manager.users.type.getSubOptions [ ]'';
              };
            };
          };
        };
        golangci-lint = {
          initialization_options = {
            command = [
              "golangci-lint"
              "run"
              "--output.json.path=stdout"
              "--show-stats=false"
            ];
          };
        };
        gopls = {
          initialization_options = {
            "formatting.gofumpt" = true;
            "formatting.newGoFileHeader" = true;
            hints = {
              # I don't like inlay hints in Go
              assignVariableTypes = false;
              compositeLiteralFields = false;
              compositeLiteralTypes = false;
              constantValues = false;
              functionTypeParameters = false;
              parameterNames = false;
              rangeVariableTypes = false;
            };
            "ui.diagnostic.analyses" = {
              appendclipped = true;
              shadow = true;
              slicesdelete = true;
            };
            "ui.diagnostic.staticcheck" = true;
            "ui.diagnostic.vulncheck" = "Imports";
            "ui.documentation.hoverKind" = "FullDocumentation";
            "ui.navigation.symbolScope" = "workspace";
          };
        };
        rust-analyzer = {
          initialization_options = {
            cargo = {
              allTargets = true;
            };
            check = {
              allTargets = true;
              command = "clippy";
              extraArgs = [ "--all-features" ];
            };
            inlayHints = {
              closingBraceHints = {
                enable = false;
              };
            };
          };
        };
        tombi = {
          binary = {
            arguments = [ "lsp" ];
            env = {
              NO_COLOR = "true";
            };
          };
        };
        yaml-language-server = {
          settings = {
            yaml = {
              schemas = {
                "https://raw.githubusercontent.com/score-spec/spec/main/score-v1b1.json" = "**/score.yaml";
              };
              customTags = [
                "!And scalar"
                "!And mapping"
                "!And sequence"
                "!If scalar"
                "!If mapping"
                "!If sequence"
                "!Not scalar"
                "!Not mapping"
                "!Not sequence"
                "!Equals scalar"
                "!Equals mapping"
                "!Equals sequence"
                "!Or scalar"
                "!Or mapping"
                "!Or sequence"
                "!FindInMap scalar"
                "!FindInMap mapping"
                "!FindInMap sequence"
                "!Base64 scalar"
                "!Base64 mapping"
                "!Base64 sequence"
                "!Cidr scalar"
                "!Cidr mapping"
                "!Cidr sequence"
                "!Ref scalar"
                "!Ref mapping"
                "!Ref sequence"
                "!Sub scalar"
                "!Sub mapping"
                "!Sub sequence"
                "!GetAtt scalar"
                "!GetAtt mapping"
                "!GetAtt sequence"
                "!GetAZs scalar"
                "!GetAZs mapping"
                "!GetAZs sequence"
                "!ImportValue scalar"
                "!ImportValue mapping"
                "!ImportValue sequence"
                "!Select scalar"
                "!Select mapping"
                "!Select sequence"
                "!Split scalar"
                "!Split mapping"
                "!Split sequence"
                "!Join scalar"
                "!Join mapping"
                "!Join sequence"
                "!Condition scalar"
                "!Condition mapping"
                "!Condition sequence"
              ];
            };
          };
        };
      };
      outline_panel = {
        dock = "right";
      };
      preview_tabs = {
        enabled = true;
      };
      project_panel = {
        dock = "left";
        auto_fold_dirs = false;
        entry_spacing = "standard";
        sticky_scroll = false;
      };
      show_signature_help_after_edits = true;
      soft_wrap = "editor_width";
      tabs = {
        file_icons = true;
      };
      terminal = {
        blinking = "on";
        cursor_shape = "bar";
        default_height = 400;
        detect_venv = {
          on = {
            directories = [
              ".venv"
              "venv"
            ];
          };
        };
        font_family = "GeistMono Nerd Font";
        font_size = 12.5;
        line_height = "standard";
        toolbar = {
          breadcrumbs = false;
        };
      };
      theme = "Catppuccin Macchiato - No Italics";
      title_bar = {
        show_branch_status_icon = true;
      };
      toolbar = {
        agent_review = false;
        breadcrumbs = true;
        code_actions = true;
        quick_actions = true;
        selections_menu = true;
      };
      ui_font_family = "Geist";
      ui_font_size = 16;
      use_smartcase_search = true;
    };
  };
}
