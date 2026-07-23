{
  flake.modules.darwin.base = { pkgs, lib, ... }: {
    # Nixpkgs ships Zed's CLI as `zeditor`, but Raycast's zed-recent-projects
    # extension looks for it named `zed` and only checks /usr/local/bin
    # so a symlink there is the only reliable option.
    system.activationScripts.postActivation.text = lib.mkAfter ''
      if [ -e /usr/local/bin/zed ] && [ ! -L /usr/local/bin/zed ]; then
        echo "zed-cli: /usr/local/bin/zed exists and is not a symlink; leaving it untouched" >&2
      else
        mkdir -p /usr/local/bin
        ln -sfn ${lib.getExe pkgs.zed-editor} /usr/local/bin/zed
      fi
    '';
  };
}
