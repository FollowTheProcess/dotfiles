{ config, ... }:
{
  programs.television = {
    enable = true;
    enableZshIntegration = false; # Would override atuin's shell history

    settings = {
      default_channel = "dev";
    };

    channels = {
      channels = {
        metadata = {
          name = "channels";
          description = "A channel to find and select other channels";
        };
        source.command = "tv list-channels";
        keybindings.enter = "actions:zap";
        actions.zap = {
          description = "Switch to the channel";
          command = "tv '{}'";
          mode = "execute";
        };
        preview.command = "bat -n --color=always ${config.home.homeDirectory}/.config/television/cable/'{}'.toml";
      };

      dev = {
        metadata = {
          name = "dev";
          description = "Find git repositories under ${config.home.homeDirectory}/Development";
          requirements = [
            "fd"
            "bat"
          ];
        };
        source.command = "fd -H -t d -g '.git' ${config.home.homeDirectory}/Development -x echo {//}";
        preview.command = "sh -c 'bat -n --color=always \"{}/README.md\" 2>/dev/null || ls -la \"{}\"'";
        keybindings.enter = "actions:open";
        actions.open = {
          description = "Open the project in Zed";
          command = "zed '{}'";
          mode = "execute";
        };
      };

      dirs = {
        metadata = {
          name = "dirs";
          description = "A channel to select from directories";
          requirements = [ "fd" ];
        };
        source.command = [
          "fd -t d"
          "fd -t d --hidden"
        ];
        preview.command = "^ls -la --color=always '{}'";
        keybindings.shortcut = "f2";
      };

      downloads = {
        metadata = {
          name = "downloads";
          description = "Browse recent files in Downloads folder";
          requirements = [
            "fd"
            "bat"
          ];
        };
        source.command = "sh -c 'fd -t f . ${config.home.homeDirectory}/Downloads 2>/dev/null | head -200'";
        preview = {
          command = "sh -c 'bat -n --color=always \"{}\" 2>/dev/null || file \"{}\"'";
          env.BAT_THEME = "ansi";
        };
        keybindings = {
          enter = "actions:open";
          ctrl-d = "actions:delete";
          ctrl-m = "actions:move";
        };
        actions = {
          open = {
            description = "Open the selected file with default application";
            command = "^open '{}'";
            mode = "fork";
          };
          delete = {
            description = "Delete the selected file";
            command = "rm -i '{}'";
            mode = "execute";
          };
          move = {
            description = "Move the selected file to current directory";
            command = "mv '{}' .";
            mode = "fork";
          };
        };
      };

      env = {
        metadata = {
          name = "env";
          description = "A channel to select from environment variables";
        };
        source = {
          command = "printenv";
          output = "{split:=:1..}";
        };
        preview.command = "echo '{split:=:1..}'";
        ui = {
          layout = "portrait";
          preview_panel = {
            size = 20;
            header = "{split:=:0}";
          };
        };
        keybindings.shortcut = "f3";
      };

      files = {
        metadata = {
          name = "files";
          description = "A channel to select files and directories";
          requirements = [
            "fd"
            "bat"
          ];
        };
        source.command = [ "fd --type file --hidden --ignore --exclude '.git'" ];
        preview.command = "bat -n --color=always '{}'";
        keybindings.shortcut = "f1";
      };

      git-branch = {
        metadata = {
          name = "git-branch";
          description = "A channel to select from git branches";
          requirements = [ "git" ];
        };
        source = {
          command = "git --no-pager branch --all --format=\"%(refname:short)\"";
          output = "{split: :0}";
        };
        preview.command = "git show -p --stat --pretty=fuller --color=always '{0}'";
      };

      git-log = {
        metadata = {
          name = "git-log";
          description = "A channel to select from git log entries";
          requirements = [ "git" ];
        };
        source = {
          command = "git log --oneline --date=short --pretty=\"format:%h %s %an %cd\"";
          output = "{split: :0}";
        };
        preview.command = "git show -p --stat --pretty=fuller --color=always '{0}'";
      };

      git-reflog = {
        metadata = {
          name = "git-reflog";
          description = "A channel to select from git reflog entries";
          requirements = [ "git" ];
        };
        source = {
          command = "git reflog";
          output = "{split: :0}";
        };
        preview.command = "git show -p --stat --pretty=fuller --color=always '{0}'";
      };

      procs = {
        metadata = {
          name = "procs";
          description = "A channel to find and manage running processes";
          requirements = [
            "ps"
            "awk"
          ];
        };
        source = {
          command = "ps -e -o pid=,ucomm= | awk '{print $1, $2}'";
          display = "{split: :1}";
          output = "{split: :0}";
        };
        preview.command = "ps -p '{split: :0}' -o user,pid,ppid,state,%cpu,%mem,command | fold";
        actions.kill = {
          description = "Kill the selected process (SIGKILL)";
          command = "kill -9 {split: :0}";
          mode = "execute";
        };
        keybindings.ctrl-k = "actions:kill";
      };

      text = {
        metadata = {
          name = "text";
          description = "A channel to find and select text from files";
          requirements = [
            "rg"
            "bat"
          ];
        };
        source = {
          command = "rg . --no-heading --line-number";
          display = "[{split:\\::..2}]\t{split:\\::2..}";
          output = "{split:\\::..2}";
        };
        preview = {
          command = "bat -n --color=always '{split:\\::0}'";
          env.BAT_THEME = "ansi";
          offset = "{split:\\::1}";
        };
        ui.preview_panel.header = "{split:\\::..2}";
      };
    };
  };
}
