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
      extensions = with pkgs.vscode-extensions; [
        # arrterian.nix-env-selector
        bbenoist.Nix
        brettm12345.nixfmt-vscode
        ms-vscode-remote.remote-ssh
        matklad.rust-analyzer
        # polymeilex.wgsl
        (lib.mkIf (config.luksab.arch == "x86_64") ms-vsliveshare.vsliveshare)
        brettm12345.nixfmt-vscode
      ];
    };
  };
}
