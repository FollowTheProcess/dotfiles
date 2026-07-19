{ config, ... }: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = config.my.git.user;
        email = config.my.git.email;
      };

      # TODO: No mechanism of conditionally signing tangled with it's key here
      # should I just converge on a single signing key across forges?
      signing = {
        backend = "ssh";
        behavior = "own";
        key = config.my.git.signingKey;
        backends.ssh = {
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          "allowed-signers" = toString config.my.git.allowedSignersFile;
        };
      };

      ui = {
        default-command = "log";
        paginate = "never";
        editor = "zed --wait";
      };

      git = {
        write-change-id-header = true;
        # Refuse to push scratch commits: prefix a description with wip:/private: to keep it local
        private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
      };

      templates = {
        # namespace auto-generated push bookmarks
        git_push_bookmark = ''"followtheprocess/push-" ++ change_id.short()'';
      };

      revset-aliases = {
        # Nearest bookmark at or below a given revision
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
      };

      aliases = {
        # Drag the closest bookmark up to the parent of the working copy
        tug = [
          "bookmark"
          "move"
          "--from"
          "closest_bookmark(@-)"
          "--to"
          "@-"
        ];
        # Pull trunk and rebase the current stack onto it
        sync = [
          "rebase"
          "-d"
          "trunk()"
        ];
        # Show in-flight work: mutable, non-empty changes
        wip = [
          "log"
          "-r"
          "mutable() & ~empty()"
        ];
        # Discard working-copy changes, keep the empty change
        nuke = [ "restore" ];
      };

      # jj fix streams each file through stdin/stdout, so tools must read stdin and write stdout
      fix.tools = {
        gofmt = {
          command = [ "gofmt" ];
          patterns = [ "glob:'**/*.go'" ];
        };
        ruff = {
          command = [
            "ruff"
            "format"
            "--stdin-filename=$path"
            "-"
          ];
          patterns = [ "glob:'**/*.py'" ];
        };
        rustfmt = {
          command = [
            "rustfmt"
            "--emit"
            "stdout"
          ];
          patterns = [ "glob:'**/*.rs'" ];
        };
        terraform = {
          command = [
            "terraform"
            "fmt"
            "-"
          ];
          patterns = [ "glob:'**/*.tf'" ];
        };
        yamlfmt = {
          command = [
            "yamlfmt"
            "-in"
          ];
          patterns = [
            "glob:'**/*.yaml'"
            "glob:'**/*.yml'"
          ];
        };
      };

      # Catppuccin Macchiato palette mapped onto jj's default labels.
      colors = {
        "error" = {
          fg = "default";
          bold = true;
        };
        "error_source" = {
          fg = "default";
        };
        "warning" = {
          fg = "default";
          bold = true;
        };
        "hint" = {
          fg = "default";
        };
        "error heading" = {
          fg = "#ed8796";
          bold = true;
        };
        "error_source heading" = {
          bold = true;
        };
        "warning heading" = {
          fg = "#eed49f";
          bold = true;
        };
        "hint heading" = {
          fg = "#8bd5ca";
          bold = true;
        };
        "conflict_description" = "#eed49f";
        "conflict_description difficult" = "#ed8796";
        "commit_id" = "#8aadf4";
        "change_id" = "#c6a0f6"; # mauve: the headline Catppuccin accent
        "prefix" = {
          bold = true;
        };
        "rest" = "#5b6078";
        "change_offset" = {
          bold = true;
        };
        "hidden prefix" = "default";
        "author" = "#eed49f";
        "committer" = "#eed49f";
        "timestamp" = "#8bd5ca";
        "working_copies" = "#a6da95";
        "workspace_name" = "#a6da95";
        "bookmark" = "#f5bde6";
        "bookmarks" = "#f5bde6";
        "local_bookmarks" = "#f5bde6";
        "remote_bookmarks" = "#f5bde6";
        "tag" = "#f5bde6";
        "tags" = "#f5bde6";
        "git_ref" = "#a6da95";
        "git_refs" = "#a6da95";
        "git_head" = "#a6da95";
        "divergent" = "#f5bde6";
        "mutable divergent" = "#ed8796";
        "mutable divergent change_id" = "#ed8796";
        "conflict" = "#ed8796";
        "empty" = "#a6da95";
        "placeholder" = "#ed8796";
        "description placeholder" = "#eed49f";
        "empty description placeholder" = "#a6da95";
        "separator" = "#5b6078";
        "elided" = "#5b6078";
        "root" = "#a6da95";
        "working_copy" = {
          bold = true;
        };
        "working_copy commit_id" = "#b7bdf8"; # lavender (bright blue)
        "working_copy change_id" = "#f5bde6"; # pink (bright magenta)
        "working_copy author" = "#eed49f";
        "working_copy committer" = "#eed49f";
        "working_copy timestamp" = "#91d7e3"; # sky (bright cyan)
        "working_copy working_copies" = "#a6da95";
        "working_copy bookmark" = "#f5bde6";
        "working_copy bookmarks" = "#f5bde6";
        "working_copy local_bookmarks" = "#f5bde6";
        "working_copy remote_bookmarks" = "#f5bde6";
        "working_copy tag" = "#f5bde6";
        "working_copy tags" = "#f5bde6";
        "working_copy git_ref" = "#a6da95";
        "working_copy git_refs" = "#a6da95";
        "working_copy divergent" = "#f5bde6";
        "working_copy mutable divergent" = "#ee99a0"; # maroon (bright red)
        "working_copy mutable divergent change_id" = "#ee99a0";
        "working_copy conflict" = "#ee99a0";
        "working_copy empty" = "#a6da95";
        "working_copy placeholder" = "#ee99a0";
        "working_copy description placeholder" = "#eed49f";
        "working_copy empty description placeholder" = "#a6da95";
        "config_list name" = "#a6da95";
        "config_list value" = "#eed49f";
        "config_list source" = "#8aadf4";
        "config_list path" = "#f5bde6";
        "config_list overridden" = "#5b6078";
        "config_list overridden name" = "#5b6078";
        "config_list overridden value" = "#5b6078";
        "config_list overridden source" = "#5b6078";
        "config_list overridden path" = "#5b6078";
        "diff header" = "#eed49f";
        "diff empty" = "#8bd5ca";
        "diff binary" = "#8bd5ca";
        "diff file_header" = {
          bold = true;
        };
        "diff hunk_header" = "#8bd5ca";
        "diff context line_number" = {
          dim = true;
        };
        "diff removed" = {
          fg = "#ed8796";
        };
        "diff added" = {
          fg = "#a6da95";
        };
        "diff token" = {
          reverse = true;
          underline = false;
        }; # word-level: highlight the changed run
        "diff modified" = "#8bd5ca";
        "diff untracked" = "#f5bde6";
        "diff renamed" = "#8bd5ca";
        "diff copied" = "#a6da95";
        "diff access-denied" = {
          bg = "#ed8796";
        };
        "operation id" = "#8aadf4";
        "operation user" = "#eed49f";
        "operation time" = "#8bd5ca";
        "operation attributes" = "#f5bde6";
        "operation current_operation" = {
          bold = true;
        };
        "operation current_operation id" = "#b7bdf8"; # lavender
        "operation current_operation user" = "#eed49f";
        "operation current_operation time" = "#91d7e3"; # sky
        "operation current_operation attributes" = "#f5bde6";
        "node elided" = {
          fg = "#5b6078";
        };
        "node working_copy" = {
          fg = "#a6da95";
          bold = true;
        };
        "node current_operation" = {
          fg = "#a6da95";
          bold = true;
        };
        "node immutable" = {
          fg = "#91d7e3";
          bold = true;
        }; # sky (bright cyan)
        "node conflicted" = {
          fg = "#ed8796";
          bold = true;
        };
        "signature display" = "#eed49f";
        "signature key" = "#8bd5ca";
        "signature status good" = "#a6da95";
        "signature status unknown" = "#eed49f";
        "signature status bad" = "#ed8796";
        "signature status invalid" = "#ed8796";
        "arrange context commit" = {
          dim = true;
        };
      };
    };
  };
}
