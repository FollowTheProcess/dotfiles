{
  dotfiles,
  lib,
  ...
}:
{
  programs.git = {
    enable = true;
    maintenance.enable = true;
    lfs.enable = true;

    signing = {
      format = "openpgp";
      key = "667642356C177BC0";
      signByDefault = true; # commit.gpgsign + tag.gpgsign
    };

    ignores = lib.splitString "\n" (builtins.readFile (dotfiles + "/.config/git/ignore"));

    attributes = [ "* text=auto" ];

    settings = {
      user = {
        name = "Tom Fleet";
        email = "me@followtheprocess.codes";
      };

      core = {
        autocrlf = false; # leave line endings untouched
        whitespace = "error"; # flag whitespace errors in diff/apply
        preloadIndex = true; # parallel index preload, faster status
        untrackedCache = true; # cache untracked files
      };

      alias = {
        st = "status -s";
        lol = "log --oneline --graph --all";
      };

      push = {
        default = "simple"; # push current branch to its upstream
        autoSetupRemote = true;
        followTags = true; # push annotated tags alongside commits
      };

      pull.rebase = true;

      fetch = {
        prune = true; # drop refs for deleted remote branches
        pruneTags = true; # drop deleted remote tags
        all = true; # fetch from all remotes
        writeCommitGraph = true; # maintain commit-graph for faster traversal
        fsckObjects = true; # verify object integrity on fetch
      };

      rebase = {
        autoStash = true; # stash/unstash dirty tree around rebase
        autoSquash = true; # honour fixup!/squash! commits
        updateRefs = true; # update stacked branches during rebase
        missingCommitsCheck = "error"; # abort if a commit line is deleted
      };

      init.defaultBranch = "main";

      transfer.fsckObjects = true; # integrity check on any transfer
      receive.fsckObjects = true; # integrity check on push receive

      diff = {
        algorithm = "histogram"; # better rename/move detection than default
        colorMoved = "plain"; # distinguish moved lines from add/delete
        mnemonicPrefix = true; # i/ w/ c/ prefixes instead of a/ b/
        renames = true; # detect renames
        wsErrorHighlight = "all"; # highlight whitespace errors in diffs
      };

      log = {
        date = "human"; # smart relative/absolute dates
        abbrevCommit = true; # short commit hashes
        graphColors = "blue,yellow,cyan,magenta,green,red";
      };

      status = {
        showStash = true; # show stash count in status
        submoduleSummary = true; # show submodule change summary
      };

      branch.sort = "-committerdate"; # list branches by most recent commit

      tag.sort = "version:refname"; # sort tags as versions, not lexically

      column.ui = "auto"; # columnar output where it fits

      rerere = {
        enabled = true; # reuse recorded conflict resolutions
        autoupdate = true; # auto-stage replayed resolutions
      };

      help.autocorrect = "prompt"; # prompt before running a corrected command

      color = {
        decorate = {
          HEAD = "red";
          branch = "blue";
          tag = "yellow";
          remoteBranch = "magenta";
        };
        branch = {
          current = "magenta";
          local = "default";
          remote = "yellow";
          upstream = "green";
          plain = "blue";
        };
      };

      # Rewrite ssh to https
      url = {
        "https://github.com/".insteadOf = [
          "git@github.com:"
          "ssh://git@github.com/"
        ];
        "https://gitlab.com/".insteadOf = [
          "git@gitlab.com:"
          "ssh://git@gitlab.com/"
        ];
      };
    };
  };
}
