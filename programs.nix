{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    killall
    maim
    git
    wget
    gcc
    cargo
    rustc
    nixfmt
  ];
  services.gnome.gnome-keyring.enable = true;
}
