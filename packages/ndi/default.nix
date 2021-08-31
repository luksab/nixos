{ lib, stdenv, requireFile, avahi }:

stdenv.mkDerivation rec {
  pname = "ndi";
  fullVersion = "5";
  version = builtins.head (builtins.splitVersion fullVersion);

  src = builtins.fetchGit {
    url = "ssh://git@github.com/luksab/nixos-obs-shell.git";
    rev = "c8943884ad82cde6b5bc1e08acc2068f3b450892";
  };

  buildInputs = [ avahi ];

  unpackPhase = ''
    unpackFile ${src}/InstallNDISDK_v4_Linux.tar.gz
    echo y | ./InstallNDISDK_v4_Linux.sh
    sourceRoot="NDI SDK for Linux";
  '';

  installPhase = ''
    mkdir $out
    mv bin/x86_64-linux-gnu $out/bin
    for i in $out/bin/*; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$i"
    done
    patchelf --set-rpath "${avahi}/lib:${stdenv.cc.libc}/lib" $out/bin/ndi-record
    mv lib/x86_64-linux-gnu $out/lib
    for i in $out/lib/*; do
      if [ -L "$i" ]; then continue; fi
      patchelf --set-rpath "${avahi}/lib:${stdenv.cc.libc}/lib" "$i"
    done
    mv include examples $out/
    mkdir -p $out/share/doc/${pname}-${version}
    mv licenses $out/share/doc/${pname}-${version}/licenses
    mv logos $out/share/doc/${pname}-${version}/logos
    mv documentation/* $out/share/doc/${pname}-${version}/
  '';

  # Stripping breaks ndi-record.
  dontStrip = true;

  meta = with lib; {
    homepage = "https://ndi.tv/sdk/";
    description = "NDI Software Developer Kit";
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
    license = licenses.unfree;
  };
}
