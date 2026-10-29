let
  run = "/Library/Application Support/AikidoSecurity/EndpointProtection/run";
  node = "${run}/endpoint-protection-node-combined-ca.pem";
  openssl = "${run}/endpoint-protection-openssl-combined-ca.pem";
  pip = "${run}/endpoint-protection-pip-combined-ca.pem";
  ruby = "${run}/endpoint-protection-ruby-combined-ca.pem";
in
{
  flake.modules.homeManager.work = {
    # ZDOTDIR is ~/.config/zsh, Aikido doesn't respect this so these all get
    # written to the wrong place so here they are manually
    home.sessionVariables = {
      NODE_EXTRA_CA_CERTS = node;
      NODE_USE_SYSTEM_CA = "1";
      SSL_CERT_FILE = openssl;
      CURL_CA_BUNDLE = openssl;
      PIP_CERT = pip;
      REQUESTS_CA_BUNDLE = pip;
      POETRY_CERTIFICATES_PYPI_CERT = pip;
      BUNDLE_SSL_CA_CERT = ruby;
    };
  };
}
