{ lib, stdenv, fetchFromGitHub, gcc, cmake }:

stdenv.mkDerivation rec {
  pname = "objectbox-bin";
  version = "v0.14.0";
  arch = "linux-aarch64";

  src = builtins.fetchurl {
    url =
      "https://github.com/objectbox/objectbox-c/releases/download/${version}/objectbox-${arch}.tar.gz";
    sha256 = "sha256:0zm7y1pc8jdkq54jl67ikl93kqxzhs5cz50a6f1z1ym4jjhsbs8d";
  };
  # src = fetchFromGitHub {
  #   owner = "objectbox";
  #   repo = "objectbox-c";
  #   rev = version;
  #   sha256 = "sha256-ymqxGAD0usHg7JT+GIZj2Dr/9h/cIUaETOv8YQg0GjU=";
  # };

  # buildInputs = [ gcc cmake ];

  unpackPhase = ''
    unpackFile ${src}
    ls -lah
    # echo y | ./InstallNDISDK_v4_Linux.sh
    # sourceRoot="NDI SDK for Linux";
  '';

  installPhase = ''
    mkdir $out
    mv * $out/
  '';

  meta = with lib; {
    homepage = "https://objectbox.io/";
    description = "ObjectBox is a superfast database for objects.";
    platforms =
      [ "x86_64-linux" "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    hydraPlatforms = [ ];
    license = licenses.asl20;
  };
}
