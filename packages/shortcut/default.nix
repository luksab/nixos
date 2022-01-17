{ stdenv, fetchFromGitHub, nodePackages }:

stdenv.mkDerivation rec {
  pname = "shortcut";
  version = "7e2847fe5d6b5e3199fb15dae2496b4d24832972";

  src = fetchFromGitHub {
    owner = "luksab";
    repo = "Shortcut";
    rev = version;
    sha256 = "sha256-cAkc0mBLA0b8k6aVsTjUSP1MuPg/jrj3ThcpyynUT9M=";
  };

  installPhase = ''
    mkdir -p $out/bin/
    cp -r * $out/bin/
  '';
}
