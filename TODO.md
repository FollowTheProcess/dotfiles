# TODO

- [x] Set up zsh properly in nix (aliases, abbreviations etc.) use dotfiles as a guide
- [x] See what else I can move into nix from .config
- [x] Can we reliably install ghostty and claude (and other brew casks)
      Ghostty yes, other UI casks not really
- [ ] For all my homebrew tap clis, can I have a flake for each and install that way?
- [x] What other system settings can I do?
- [x] Delete anything I don't now need
- [x] Symlink AGENTS and CLAUDE with nix
- [x] How can I do the `bootstrap.sh` tasks declaratively
- [x] `.ssh` config with nix
- [x] mise task to update `flake.lock`
- [x] Wire up `maintenance` to do flake update and rebuild. Is this even needed actually? Nope!
- [ ] Move skills out of here into their own repo set up
- [ ] Manage claude in here, bonus means it now can't change it's own config!
- [x] Try https://github.com/michel-kraemer/zsh-patina
- [x] Manage awscli, ghostty, difftastic, fastfetch in programs
- [x] How to set up AWS CLI with granted credential helper
- [ ] Learn how to make flakes for packages I want to distribute, also devShells etc.
- [x] Add devenv as a program
- [ ] Look at sops nix for secrets (Github PAT, SSH keys, GPG etc.)
- [x] Proper multi-host architecture so I can manage my work laptop too
- [ ] Investigate how to make `nix flake update` also bump the catppuccin theme repos (if it's possible)
- [ ] See if this "dendritic" thing is worth it, maybe migrate

## Secrets

Seems like sops is the best bet? Most widely used?

1. Generate a private key with age (probably also save it in 1Password or something)

```bash
nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt
```

2. Get it's public key

```bash
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```

3. Create a `.sops.yaml` file next to `flake.nix`, like this:

```yaml
keys:
  - &whatever age.... # <- the public key from step 2
creation_rules:
  - path_regex: secrets/secrets.yaml$
    key_groups:
      - age:
          - *whatever
```

4. Create the secrets file

Can be per host like:

```bash
secrets/
  common.yaml    # tokens both machines need
  onyx.yaml      # personal-only
  work.yaml      # work-only
```

```bash
# Personal secrets
cd secrets && sops onyx.yaml
```

This will open up `$EDITOR` and let you insert whatever content you want for the secret, when you close
`$EDITOR` it will be stored in place but encrypted by the key so you can commit it

5. Install `sops-nix`

```nix
inputs = {
  # ...
  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};

# ...

modules = [
  ./nix/hosts/${host}/default.nix
  nix-homebrew.darwinModules.nix-homebrew
  sops-nix.darwinModules.sops # <- new
];
```

6. Configure `sops`

Probably best in a programs/sops.nix

````nix
{ config, dotfiles, ... }: {
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = dotfiles + "/secrets/onyx.yaml";
    defaultSopsFormat = "yaml";

    secrets = {
      github_token = { }; # Reads from the file

      # Can also reference a nested yaml thing
      "some/deeply/nested/secret" = { };
      # Would read from:
      # ```yaml
      # some:
      #   deeply:
      #     nested:
      #       secret: shhh # <- here
      # ```
    };
  };
}
````
