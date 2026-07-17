{ ... }: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
    config = {
      global = {
        load_dotenv = true; # Allow .env as well as .envrc
        strict_env = true;
      };
      whitelist.prefix = [ "~/Development" ]; # Trust anything under here
    };
  };
}
