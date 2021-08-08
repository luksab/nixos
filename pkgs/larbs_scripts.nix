{ stdenv }:

stdenv.mkDerivation rec {
  name = "larbs-scripts-${version}";
  version = "2021-05-08";

  src = builtins.fetchTarball {
    url = "https://github.com/LukeSmithxyz/voidrice/archive/master.tar.gz";
  };

  installPhase = ''
    mkdir -p $out/bin/
    cp -r .local/bin/* $out/bin/
    cp -r .local/bin/statusbar/* $out/bin/
    ls -lah $out
  '';
    #   mkdir -p $out/share/zsh/site-functions
    # cp pure.zsh $out/share/zsh/site-functions/prompt_pure_setup
    # cp async.zsh $out/share/zsh/site-functions/async
}