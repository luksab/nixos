{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    firefox
    gcc
    cargo
    rustc
    nixfmt
    spotify
    discord
  ];
}
