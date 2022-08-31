{ pkgs, fetchFromGitHub }:

pkgs.vimUtils.buildVimPlugin {
  pname = "copilot-cmp";
  version = "2022-04-11";
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    rev = "1bfbaf5b027ee4d3d3dbc828c8bfaef2c45d132d";
    sha256 = "sha256-hm/8q08aIVWc5thh31OVpVoksVrqKD+rSHbUTxzzHaU=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot-cmp/";
}
