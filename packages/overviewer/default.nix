{ pkgs, lib, stdenv, fetchFromGitHub, wrapPython, makeWrapper }:
let
  python-depends = python-packages:
    with python-packages; [
      setuptools
      numpy
      pillow
      # other python packages you want
    ];
  python = pkgs.python3.withPackages python-depends;
  wrapper = pkgs.writeText "overviewer" (''
    ${python}/bin/python3 $out/libexec/overviewer/overviewer.py
  '');

in stdenv.mkDerivation rec {
  pname = "overviewer";
  #version = "v0.17.0";
  version = "2402e410cfb0dce1068bc42b2854c00791d6f108";

  buildInputs = [ python makeWrapper wrapPython ];

  srcs = [
    (fetchFromGitHub {
      owner = "overviewer";
      repo = "Minecraft-Overviewer";
      rev = version;
      name = pname;
      #sha256 = "sha256:1hqbd6m850qqs9ck54j2gf54kjhn4zr3as65rpx9rglmjx8ymh4j";
      sha256 = "sha256-F4u9cc7PKJSGycKghFBdZcpoFexT9U4joC3wF6S3OmU=";
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
    ${python}/bin/python3 --version
    ${python}/bin/python3 setup.py build
  '';

  installPhase = ''
    mkdir -p $out/bin $out/libexec/overviewer
    cp -R ./overviewer_core/ overviewer.py $out/libexec/overviewer

    # Can't just symlink to the main script, since it uses __file__ to
    # import bundled packages and manage the service
    #cp ${wrapper} $out/bin/overviewer
    cat << EOF > $out/bin/overviewer
    #!${pkgs.bash}/bin/bash
    ${python}/bin/python3 $out/libexec/overviewer/overviewer.py \$@
    EOF
    chmod +x $out/bin/overviewer
    # makeWrapper $out/libexec/overviewer/overviewer.py $out/bin/overviewer
    # wrapPythonProgramsIn "$out/libexec/overviewer" "$pythonPath"
  '';

  checkPhase = ''
    runHook preCheck

    $out/bin/overviewer --help

    runHook postCheck
  '';

  meta = with lib; {
    description =
      "a high-resolution Minecraft world renderer with a LeafletJS interface";
    homepage = "https://overviewer.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ luksab ];
  };
}
