{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "larbs-scripts";
  version = "c20acc474f7054f65c6ee410c0e26dcbcfc89927";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = "voidrice";
    rev = version;
    sha256 = "sha256-V2Ehmr6hMdkBlXsDMcfLLxGj+xCs3Sx2rOX6HImsNtY=";
  };

  patches = [ ./diff.patch ];

  installPhase = ''
    mkdir -p $out/bin/
    cp -r .local/bin/* $out/bin/
    cp -r .local/bin/statusbar/* $out/bin/
    ls -lah $out
  '';
}
