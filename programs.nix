{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    killall
    maim
    git
    wget
    unzip
    gcc
    screen
    cargo
    rustc
    nixfmt
  ];
  services.gnome.gnome-keyring.enable = true;
}
