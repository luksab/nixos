{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "larbs-scripts";
  version = "5f3576da169c7dc15dfb7e7d6e2f71db27583354";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = "voidrice";
    rev = version;
    sha256 = "sha256-toR8QjILQwlztp8AViy3gNEWdilZVBF4xyinVYfCx5s=";
  };

  patches = [ ./diff.patch ];

  installPhase = ''
    mkdir -p $out/bin/
    cp -r .local/bin/* $out/bin/
    cp -r .local/bin/statusbar/* $out/bin/
    ls -lah $out
  '';
}
