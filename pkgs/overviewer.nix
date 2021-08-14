{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "overviewer-${version}";
  version = "v0.17.0";

  srcs = [
    (pkgs.fetchFromGitHub {
      owner = "overviewer";
      repo = "Minecraft-Overviewer";
      rev = version;
      name = name;
      sha256 = "sha256:1hqbd6m850qqs9ck54j2gf54kjhn4zr3as65rpx9rglmjx8ymh4j";
    })
    (pkgs.fetchFromGitHub {
      owner = "python-pillow";
      repo = "Pillow";
      rev = "8.3.1";
      name = "pillow";
      sha256 = "sha256:0nbl7w813c7k8wpmldlgipqnn9bdzrjgxyg256zqlx9nxcfmaalm";
    })
  ];

  sourceRoot = name;

  buildInputs = with pkgs.python39Packages; [ pkgs.python39 numpy pillow ];
  propagatedBuildInputs = with pkgs.python39Packages; [ pkgs.python39 numpy pillow ];

  preBuild = ''
    chmod -R u+w ../pillow
    ln -s ../pillow .
    make ../pillow
  '';

  installPhase = ''
    export PIL_INCLUDE_DIR=./pillow/src/libImaging
    python3.9 setup.py build
    mkdir -p $out/bin/
    cp -r ./overviewer_core/ $out/bin/
    cp ./overviewer.py $out/bin/
  '';
}
