{ pkgs, fetchFromGitHub }:

pkgs.vimUtils.buildVimPlugin {
  pname = "copilot-cmp";
  version = "2022-04-11";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot-cmp";
    rev = "4a8909fd63dff71001b22a287daa3830e447de70";
    sha256 = "sha256-QcxuyBZDKVJ4QLkugfLLaZ6FE0ZE4hD1dQYwm8FH+Mg=";
  };
  meta.homepage = "https://github.com/zbirenbaum/copilot-cmp/";
}
