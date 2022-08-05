{ buildGoModule, fetchFromGitHub }:

buildGoModule {
  name = "Discord Notify Go";
  src = fetchFromGitHub {
    owner = "luksab";
    repo = "discord_notify_go";
    rev = "a49a4397d683c87469105bb359733f6b1a99f72e";
    sha256 = "sha256-ZCPfofhpFyoTKKrXdZI8rI5Uarrz6r8Y6wJ6PMbHgWA=";
  };
  vendorSha256 = "sha256-RaWIa8SFbnf+YVWml8PTkRfkSOeKUYC+jQz9qqLXeJo=";
}
