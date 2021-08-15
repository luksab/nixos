{ pkgs, lib, fetchFromGitHub, buildPythonApplication, setuptools, wrapPython, makeWrapper }:

buildPythonApplication rec {
  pname = "overviewer";
  version = "v0.17.0";

  pythonPath = with pkgs.python3Packages; [ setuptools numpy pillow];
  nativeBuildInputs = [ wrapPython makeWrapper ];

  srcs = [
    (fetchFromGitHub {
      owner = "overviewer";
      repo = "Minecraft-Overviewer";
      rev = version;
      name = pname;
      sha256 = "sha256:1hqbd6m850qqs9ck54j2gf54kjhn4zr3as65rpx9rglmjx8ymh4j";
    })
    (fetchFromGitHub {
      owner = "python-pillow";
      repo = "Pillow";
      rev = "8.3.1";
      name = "pillow";
      sha256 = "sha256:0nbl7w813c7k8wpmldlgipqnn9bdzrjgxyg256zqlx9nxcfmaalm";
    })
  ];

  sourceRoot = pname;

  preBuild = ''
    chmod -R u+w ../pillow
    ln -s ../pillow .

    export PIL_INCLUDE_DIR=./pillow/src/libImaging
    python3 setup.py build
  '';

  installPhase = ''
    mkdir -p $out/bin $out/libexec/overviewer
    cp -R ./overviewer_core/ overviewer.py $out/libexec/overviewer

    # Can't just symlink to the main script, since it uses __file__ to
    # import bundled packages and manage the service
    makeWrapper $out/libexec/overviewer/overviewer.py $out/bin/overviewer
    wrapPythonProgramsIn "$out/libexec/overviewer" "$pythonPath"
  '';

  checkPhase = ''
    runHook preCheck

    $out/bin/overviewer --help

    runHook postCheck
  '';

  meta  = with lib; {
    description = "a high-resolution Minecraft world renderer with a LeafletJS interface";
    homepage = "https://overviewer.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ luksab ];
  };
}