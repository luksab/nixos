{ fetchurl, lib, stdenv, squashfsTools, xorg, alsaLib, makeWrapper, openssl
, freetype, glib, pango, cairo, atk, gdk-pixbuf, gtk2, cups, nspr, nss, libpng
, libnotify, libgcrypt, systemd, fontconfig, dbus, expat, ffmpeg_3, curl, }:

let
  version = "1.0.4";
  rev = "14";

  deps = [
    # curl
  ];

in stdenv.mkDerivation {
  pname = "lenovo_wwan_dpr";
  inherit version;

  srcs = [
    (fetchurl {
      url =
        "https://api.snapcraft.io/api/v1/snaps/download/LLzS0Nb7rtM5RH6dNadpAzWAiRfHuefk_${rev}.snap";
      sha512 =
        "e2b51ef0c7d438f2bebc1d3feceaa039c023818fffd2407260301b122e54d6629e242128205c11037f82cb46cab53cbf2a0901784bf732b386d61b794ad59252";
    })
    ./fcc-unlock.c
  ];

  buildInputs = [ squashfsTools makeWrapper ];

  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$(echo $srcs[0])" 'usr/lib/mbim2sar.so'
    cd squashfs-root
    ls
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    gcc $(echo $srcs | awk '{print $2}') -o fcc-unlock
    # sudo env VERBOSE=1 ./fcc-unlock
    mkdir -p $out/bin
    cp fcc-unlock $out/bin/lenovo_wwan_dpr
    cp usr/lib/mbim2sar.so $out/bin/mbim2sar.so

    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.unfree;
    maintainers = with maintainers; [ luksab ];
    platforms = [ "x86_64-linux" ];
  };
}
