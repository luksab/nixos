{ stdenv, fetchFromGitHub, nodePackages }:

stdenv.mkDerivation rec {
  pname = "shortcut";
  version = "7f9905adfd26952394c7d6c99086f26d0a899f66";

  src = fetchFromGitHub {
    owner = "luksab";
    repo = "Shortcut";
    rev = version;
    sha256 = "sha256-+O4rcWBvoLmYzrBm6xXAYqmuGTqDHN4Xr/Q+UmT7IsY=";
  };

  installPhase = ''
    mkdir -p $out/bin/
    cp -r * $out/bin/
  '';
}
