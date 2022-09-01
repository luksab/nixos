{ lib, stdenv, fetchFromGitHub, writeText, xorgproto, libX11, libXext
, libXrandr, linux-pam
# default header can be obtained from
# https://git.suckless.org/slock/tree/config.def.h
, conf ? null }:

with lib;
stdenv.mkDerivation rec {
  pname = "slock";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "Miciah";
    repo = "slock-pam";
    rev = "eac9fe7bad960ce2566c1a159bb510194c711081";
    sha256 = "sha256-1Q42DOCTLjrvJS9TbC3Ml4jwVrH5nVa+UF+hUw7nto0=";
  };

  buildInputs = [ xorgproto libX11 libXext libXrandr linux-pam ];

  installFlags = [ "PREFIX=$(out)" ];

  postPatch = "sed -i '/chmod u+s/d' Makefile";

  makeFlags = [ "CC:=$(CC)" ];

  meta = {
    homepage = "https://tools.suckless.org/slock";
    description = "Simple X display locker";
    longDescription = ''
      Simple X display locker. This is the simplest X screen locker.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
  };
}
