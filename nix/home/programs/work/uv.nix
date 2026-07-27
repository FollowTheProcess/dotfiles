{
  flake.modules.homeManager.work = {
    # https://docs.astral.sh/uv/concepts/authentication/certificates/#system-certificates
    programs.uv.settings.system-certs = true;
  };
}
