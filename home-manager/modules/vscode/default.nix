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
          eamodio.gitlens
          bbenoist.nix
          brettm12345.nixfmt-vscode
          arrterian.nix-env-selector
          ms-vscode-remote.remote-ssh
          matklad.rust-analyzer
          (lib.mkIf (config.luksab.arch == "x86_64") pkgs.vsliveshare-new)
          brettm12345.nixfmt-vscode
          james-yu.latex-workshop
          valentjn.vscode-ltex
          (lib.mkIf (config.luksab.arch == "x86_64") ms-python.python)

          (lib.mkIf (config.luksab.arch == "x86_64") ms-vscode.cpptools)
          esbenp.prettier-vscode
          tamasfe.even-better-toml
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "wgsl";
          publisher = "polymeilex";
          version = "0.1.11";
          sha256 = "sha256-u1vZ+iQASORBGa/Ck9bXz45iUQaL0Xc0tDLlAN5l6Ow=";
        }] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "wgsl-analyzer";
          publisher = "wgsl-analyzer";
          version = "0.2.0";
          sha256 = "sha256-il4coUjCAa3KEMBfnw9ZT7g2Jv86BxLLHB/EnVrbsyY=";
        }] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.209.6";
          sha256 = "sha256-SOYTUBY8EGLTYhNkQC56apAwgV0feCe9ydU8UOtRdbc=";
        }];
    };
  };
}
