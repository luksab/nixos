{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.luksab.programs.vscode;
  my-python-packages = python-packages:
    with python-packages; [
      pandas
      requests
      numpy
      # other python packages you want
    ];
  python-with-my-packages = pkgs.python3.withPackages my-python-packages;
in {
  options.luksab.programs.vscode.enable = mkEnableOption "enable vscode";
  config = mkIf cfg.enable {
    home.packages = [ python-with-my-packages ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions;
        [
          # arrterian.nix-env-selector
          bbenoist.nix
          brettm12345.nixfmt-vscode
          ms-vscode-remote.remote-ssh
          matklad.rust-analyzer
          (lib.mkIf (config.luksab.arch == "x86_64") pkgs.vsliveshare-new)
          brettm12345.nixfmt-vscode
          tomoki1207.pdf
          ms-python.python

          ms-vscode.cpptools
          esbenp.prettier-vscode
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "wgsl";
          publisher = "polymeilex";
          version = "0.1.11";
          sha256 = "sha256-u1vZ+iQASORBGa/Ck9bXz45iUQaL0Xc0tDLlAN5l6Ow=";
        }] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "wgsl-analyzer";
          publisher = "wgsl-analyzer";
          version = "0.1.0";
          sha256 = "sha256-Oat/axLsM7kz/16oA3ZtKS1ygg5yenatnwOE3HHjYI4=";
        }];
    };
  };
}
