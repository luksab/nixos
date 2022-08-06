{ buildGoModule, fetchFromGitHub }:

buildGoModule {
  name = "Discord Notify Go";
  src = fetchFromGitHub {
    owner = "luksab";
    repo = "discord_notify_go";
    rev = "29bfde51b63c715a7342e5b4037259a442a3471f";
    sha256 = "sha256-7eFnNRTru4yTS3XyPOth0WGuDNOv6/oDhia+NmItUXA=";
  };
  vendorSha256 = "sha256-RaWIa8SFbnf+YVWml8PTkRfkSOeKUYC+jQz9qqLXeJo=";
}
