{ buildGoModule, fetchFromGitHub }:

buildGoModule {
  name = "Discord Notify Go";
  src = fetchFromGitHub {
    owner = "luksab";
    repo = "discord_notify_go";
    rev = "8c6ee59498ed6b3cbf6f39fc7613306fbff494e6";
    sha256 = "sha256-eSCK6lq0L2Kl8DgINy19JQ65py6VAh6tLFpK1Gly7e0=";
  };
  vendorSha256 = "sha256-RaWIa8SFbnf+YVWml8PTkRfkSOeKUYC+jQz9qqLXeJo=";
}
