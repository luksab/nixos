{ config, pkgs, ... }:

{
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  imports = [ ../suckless.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  networking.interfaces.wlp0s20f3.useDHCP = true;

  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlp0s20f3" ];

  networking.wireless.networks = {
    Salami = { # SSID with no spaces or special characters
      psk = "ckqc-go05-m2kn";
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
}
