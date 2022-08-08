{ buildGoModule, fetchFromGitHub }:

buildGoModule {
  name = "Discord Notify Go";
  src = fetchFromGitHub {
    owner = "luksab";
    repo = "discord_notify_go";
    rev = "4fe8b6b0c8232692a61194865335340233e53b79";
    sha256 = "sha256-2bbflmN8qQlWwtNf+Tv9/LEDEAoH5XzEx3F5vMl0u6c=";
  };
  vendorSha256 = "sha256-RaWIa8SFbnf+YVWml8PTkRfkSOeKUYC+jQz9qqLXeJo=";
}
