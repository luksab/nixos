{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.programs.vscode;

in {
  options.luksab.programs.vscode.enable = mkEnableOption "enable vscode";
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.Nix
        ms-vscode-remote.remote-ssh
        matklad.rust-analyzer
        (lib.mkIf (config.luksab.arch == "x86_64") ms-vsliveshare.vsliveshare)
        brettm12345.nixfmt-vscode
      ];
    };
  };
}
