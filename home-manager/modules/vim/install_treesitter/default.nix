{ pkgs ? import <nixpkgs> { } }:

with pkgs;
pkgs.mkShell {
  buildInputs = [
    gcc
    nodejs
    neovim
    tree-sitter
    (python39.withPackages (pp: with pp; [
      pynvim
    ]))
  ];
}
