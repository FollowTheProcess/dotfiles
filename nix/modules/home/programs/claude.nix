{ config, ... }: {
  programs.claude-code = {
    enable = true;
    # I prefer XDG_CONFIG_HOME for everything
    configDir = "${config.xdg.configHome}/claude";
    context = ''
      # Guidance for Agents

      Global guidance for all Agents, regardless of current project.

      - Application/tool config is managed via ~/dotfiles and nix/nix-darwin. Never try and imperitively change configuration.
      - Unless I explicitly tell you to commit, git commits will be handled by me either during or at the end of a task. You should not commit.
      - Documentation changes must be run through the humanizer skill and corrected if needed
      - Only add comments in exceptional cases, to document _why_ a decision was made, and keep them incredibly brief. If the comment just explains
        what the code is doing, don't bother
      - Always follow TDD
      - Think deeply and understand the full context
      - If you're unsure: ask me
      - Don't make assumptions, find facts
      - Keep docs current on changes
      - Use pure functions whenever possible
      - Prefer early returns to nesting
      - Correctness beats performance
      - Use language specific skills for more details about a specific language's standards
    '';
    lspServers = {
      go = {
        command = "gopls";
        extensionToLanguage = {
          ".go" = "go";
        };
      };
      ty = {
        command = "ty";
        args = [ "server" ];
        extensionToLanguage = {
          ".py" = "python";
          ".pyi" = "python";
        };
      };
      rust-analyzer = {
        command = "rust-analyzer";
        extensionToLanguage = {
          ".rs" = "rust";
        };
      };
    };
    settings = {
      model = "claude-opus-4-8";
      theme = "dark-ansi";
      tui = "fullscreen";
      includeCoAuthoredBy = false;
      skipWorkflowUsageWarning = true;
      skipAutoPermissionPrompt = true;
      permissions = {
        allow = [
          "Bash(* --version)"
          "Bash(* -version)"
          "Bash(* --help)"
          "Bash(* -help)"
          "Bash(allium *)"
          "Bash(go *)"
          "Bash(cargo *)"
          "Bash(uv *)"
          "Bash(ruff *)"
          "Bash(ty *)"
          "Bash(golangci-lint *)"
          "Bash(staticcheck *)"
          "Bash(wc *)"
          "Bash(ls *)"
          "Bash(cat *)"
          "Bash(grep *)"
          "Bash(rg *)"
          "Bash(find *)"
          "Bash(fd *)"
          "Bash(head *)"
          "Bash(tail *)"
          "Bash(awk *)"
          "Bash(terraform init *)"
          "Bash(terraform validate *)"
          "Bash(tflint *)"
          "Bash(git status*)"
          "Bash(git -C * status*)"
          "Bash(git diff*)"
          "Bash(git -C * diff*)"
          "Bash(git log*)"
          "Bash(git -C * log*)"
          "Bash(git show*)"
          "Bash(git -C * show*)"
          "Bash(git blame*)"
          "Bash(git -C * blame*)"
          "Bash(git ls-files*)"
          "Bash(git -C * ls-files*)"
          "Bash(git rev-parse*)"
          "Bash(git -C * rev-parse*)"
          "Bash(git describe*)"
          "Bash(git -C * describe*)"
          "Bash(git shortlog*)"
          "Bash(git -C * shortlog*)"
          "Bash(git reflog*)"
          "Bash(git -C * reflog*)"
          "Bash(git fetch*)"
          "Bash(git -C * fetch*)"
          "Bash(git worktree list*)"
          "Bash(git -C * worktree list*)"
          "Bash(gh run view *)"
          "Bash(gh run list *)"
          "Bash(obsidian search *)"
          "Bash(obsidian read *)"
          "Bash(defaults read *)"
          "Grep"
          "Glob"
          "Read"
          "Skill(go)"
          "Skill(python)"
          "Skill(terraform)"
          "Skill(tests)"
          "Skill(superpowers:*)"
          "Skill(code-review:*)"
          "Skill(obsidian:*)"
          "Skill(simplify)"
          "Skill(fewer-permission-prompts)"
          "Skill(review)"
          "Skill(security-review)"
          "WebFetch"
          "WebSearch"
        ];
        deny = [
          "Bash(rm -rf*)"
          "Bash(rm -fr*)"
          "Bash(rm -r*)"
          "Bash(rm -R*)"
          "Bash(dd if=*)"
          "Bash(mkfs*)"
          "Bash(diskutil erase*)"
          "Bash(diskutil eraseDisk*)"
          "Bash(shutdown )"
          "Bash(reboot*)"
          "Bash(sudo *)"
          "Bash(git push *)"
          "Bash(git -C * push *)"
          "Bash(git reset --hard*)"
          "Bash(git -C * reset --hard*)"
          "Bash(git clean -f*)"
          "Bash(git -C * clean -f*)"
          "Bash(git branch -D *)"
          "Bash(git -C * branch -D *)"
          "Bash(git filter-branch*)"
          "Bash(git checkout .)"
          "Bash(git restore .)"
          "Bash(git commit*)"
          "Bash(terraform apply *)"
          "Bash(terraform destroy *)"
          "Bash(terraform import *)"
          "Bash(terraform state rm *)"
          "Bash(terraform state mv *)"
          "Bash(terraform state push *)"
          "Bash(terraform taint* )"
          "Bash(terraform untaint *)"
          "Bash(terraform force-unlock *)"
          "Bash(terraform workspace delete *)"
          "Bash(tofu apply *)"
          "Bash(tofu destroy *)"
          "Bash(tofu import *)"
          "Bash(tofu state rm *)"
          "Bash(tofu state mv *)"
          "Bash(tofu state push *)"
          "Bash(tofu force-unlock *)"
          "Bash(aws *)"
          "Bash(kubectl *)"
          "Bash(helm *)"
          "Bash(docker rm -f *)"
          "Bash(docker rmi -f *)"
          "Bash(docker volume rm *)"
          "Bash(docker volume prune *)"
          "Bash(docker system prune *)"
          "Bash(docker container prune *)"
          "Bash(docker network prune *)"
          "Bash(docker image prune *)"
          "Read(~/.ssh/**)"
          "Read(~/.netrc)"
          "Read(~/.aws/**)"
          "Read(~/.gnupg/**)"
          "Read(~/.config/gcloud/**)"
          "Read(~/.config/gh/hosts.yml)"
          "Read(~/.config/op/**)"
          "Read(~/.docker/config.json)"
          "Read(~/.kube/**)"
          "Read(~/.npmrc)"
          "Read(~/.pypirc)"
          "Read(~/.git-credentials)"
          "Read(~/.cargo/credentials.toml)"
          "Read(~/.password-store/**)"
          "Read(~/.claude/.credentials.json)"
          "Read(**/.env)"
          "Read(**/.env.local)"
          "Read(**/.env.*.local)"
          "Read(**/.env.production)"
          "Read(**/.env.staging)"
          "Read(**/.env.development)"
          "Read(**/*.pem)"
          "Read(**/*.key)"
          "Read(**/*.p12)"
          "Read(**/*.pfx)"
          "Read(**/id_rsa)"
          "Read(**/id_ed25519)"
          "Read(**/id_ecdsa)"
          "Read(**/id_dsa)"
        ];
        additionalDirectories = [ "/Users/tomfleet/Development" ];
        disableBypassPermissionsMode = "disable";
      };
      enabledPlugins = {
        "superpowers@claude-plugins-official" = true;
        "code-review@claude-plugins-official" = true;
        "code-simplifier@claude-plugins-official" = true;
        "claude-md-management@claude-plugins-official" = true;
        "obsidian@obsidian-skills" = true;
      };
      extraKnownMarketplaces = {
        obsidian-skills.source = {
          source = "github";
          repo = "kepano/obsidian-skills";
        };
      };
    };
  };
}
