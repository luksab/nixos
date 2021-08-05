{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    killall
    maim
    git
    wget
    firefox
    brave
    gcc
    cargo
    rustc
    nixfmt
    spotify
    discord
  ];
}
