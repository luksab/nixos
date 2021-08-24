{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "larbs-scripts";
  version = "0a6982f1e11a2a528ea110def6fc10da6574a595";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = "voidrice";
    rev = version;
    sha256 = "sha256-qaYc2OZRoafB0SuSiI2cOhYbDfFk+7uwUTpOpE+hGW4=";
  };

  installPhase = ''
    mkdir -p $out/bin/
    cp -r .local/bin/* $out/bin/
    cp -r .local/bin/statusbar/* $out/bin/
    ls -lah $out
  '';
}
