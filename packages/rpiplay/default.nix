{ stdenv, lib, fetchgit, cmake, openssl, avahi-compat, libplist, gst_all_1
, pkg-config, pcre, libunwind, elfutils, avfs, pkgconfig
, gsettings-desktop-schemas, hicolor-icon-theme, pango, json-glib }:

stdenv.mkDerivation rec {
  name = "uxplay";

  src = fetchgit {
    url = "https://github.com/FD-/RPiPlay";
    rev = "c304f9f134fcfd856290885f43dffa8f6198a5f0";
    sha256 = "sha256-24IwnhQ19m8vlEKB4JqZpQBa7j8nRIjwtphPi2mdnaE=";
  };

  # unpackPhase = ''
  #   cd ${src}
  # '';

  buildPhase = ''
    cmake ..
    make
  '';

  installPhase = ''
    ls -lah
    mkdir -p $out/bin
    mv rpiplay $out/bin
  '';

  # preFixup = ''
  #   gappsWrapperArgs+=(
  #       --prefix GST_PLUGIN_SYSTEM_PATH : "${gst_all_1.gst-plugins-base}/lib/gstreamer-1.0/:${gst_all_1.gst-plugins-good}/lib/gstreamer-1.0/" \
  #       --prefix XDG_DATA_DIRS : "$out/share" \
  #       --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/${name}" \
  #       --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
  #       --prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share" \
  #       --prefix GI_TYPELIB_PATH : "${
  #         lib.makeSearchPath "lib/girepository-1.0" [ pango json-glib ]
  #       }"
  #   )
  # '';

  buildInputs = [
    cmake
    avfs
    elfutils
    libunwind.dev
    pcre.dev
    pkg-config
    openssl
    avahi-compat
    libplist
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ];

  runtimeDependencies = [
    gsettings-desktop-schemas
    cmake
    openssl
    pkgconfig
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
    pcre.dev
    avahi-compat
    gst_all_1.gst-libav
    libplist
    libunwind
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-vaapi
  ];
}
