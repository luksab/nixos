{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "larbs-scripts";
  version = "0a6982f1e11a2a528ea110def6fc10da6574a595";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = "voidrice";
    rev = version;
  };

  installPhase = ''
    mkdir -p $out/bin/
    cp -r .local/bin/* $out/bin/
    cp -r .local/bin/statusbar/* $out/bin/
    ls -lah $out
  '';
}
