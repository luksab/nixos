{ lib, config, pkgs, ... }:
with lib;
let cfg = config.luksab.desktop;
in {
  options.luksab.desktop = { enable = mkEnableOption "enable desktop"; };

  config = mkIf cfg.enable {
    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
    };

    fileSystems."/mnt/nas" = {
      device = "10.31.70.5:/mnt/main";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };

    environment.systemPackages = [ pkgs.rpiplay pkgs.librsvg pkgs.spice-gtk ];
    security.polkit.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    hardware.logitech.wireless.enableGraphical = true;
    hardware.logitech.wireless.enable = true;
    networking.firewall = {
      allowedUDPPorts = [ 6000 6001 7011 ];
      allowedTCPPorts = [ 7000 7100 ];
    };
    services.avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
        userServices = true;
      };
    };

    # enable yubi key
    mayniklas = {
      yubikey.enable = true;
      virtualisation.enable = true;
    };

    # enable virtualbox
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [ "lukas" ];
    virtualisation.virtualbox.host.enableExtensionPack = true;

    programs.dconf.enable = true;
    services.gvfs.enable = true;

    # enable bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    hardware.bluetooth.settings = {
      General = { Enable = "Source,Sink,Media,Socket"; };
    };

    programs.kdeconnect.enable = true;
    programs.slock.enable = true;

    luksab = {
      common.enable = true;
      xserver = {
        enable = true;
        dpi = 100;
      };
      v4l2loopback.enable = true;
      ndi.enable = true;
      scrcpy.enable = true;
      steam.enable = config.luksab.arch == "x86_64";
      metrics = { node.enable = true; };
    };
  };
}
