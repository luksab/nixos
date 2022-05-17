{ appimageTools, fetchurl }:

let
  version = "1.0.12";
in
appimageTools.wrapType1 {
  name = "Deskreen";
  src = fetchurl {
    url = "https://github.com/pavlobu/deskreen/releases/download/v${version}/Deskreen-${version}.AppImage";
    sha256 = "sha256-SuFSkczJVeAnIlWwoGZkF4jj8BEG/4PYgC8jclrBthQ=";
  };
}
