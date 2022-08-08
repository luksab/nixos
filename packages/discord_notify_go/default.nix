{ buildGoModule, fetchFromGitHub }:

buildGoModule {
  name = "Discord Notify Go";
  src = fetchFromGitHub {
    owner = "luksab";
    repo = "discord_notify_go";
    rev = "caf47f0b2a4ba96659204abc2cbe00545d64098f";
    sha256 = "sha256-75OgMGkgKrQ1Ml9WA/nrNF+RsPfNtk1bF/MUq1tsVW0=";
  };
  vendorSha256 = "sha256-tMKasxp1C7AElQMhW3MTZPLw4WWuXtlOiwntmVG9bLY=";
}
