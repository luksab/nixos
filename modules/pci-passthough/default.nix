{ lib, pkgs, config, modulesPath, ... }:
with lib;
let cfg = config.luksab.pci-passthrough;
in {
  options.luksab.pci-passthrough = {
    enable = mkEnableOption "enable basics";
    ids = mkOption {
      type = types.str;
      example = "10de:11c6,10de:0e0b";
      description = "comma separated pci ids to include";
    };
  };

  config = mkIf cfg.enable {
    # CHANGE: intel_iommu enables iommu for intel CPUs with VT-d
    # use amd_iommu if you have an AMD CPU with AMD-Vi
    # boot.kernelParams = [ "intel_iommu=on" ];
    boot.kernelParams = [ "pcie_acs_override=downstream,multifunction" "intel_iommu=on" ];
    boot.kernelPatches = [{
      name = "add-acs-overrides";
      patch = ./add-acs-overrides.patch;
    }];

    # These modules are required for PCI passthrough, and must come before early modesetting stuff
    boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];

    # CHANGE: Don't forget to put your own PCI IDs here
    boot.extraModprobeConfig = "options vfio-pci ids=${cfg.ids}";

    environment.systemPackages = with pkgs; [ virtmanager qemu OVMF ];

    virtualisation.libvirtd.enable = true;

    # CHANGE: add your own user here
    users.groups.libvirtd.members = [ "root" "lukas" ];

    # CHANGE: use 
    #     ls /nix/store/*OVMF*/FV/OVMF{,_VARS}.fd | tail -n2 | tr '\n' : | sed -e 's/:$//'
    # to find your nix store paths
    virtualisation.libvirtd.qemuVerbatimConfig = ''
      nvram = [
        "/nix/store/kavdn6j03wfdwd2v1g4bnaw8bbrskrpb-OVMF-202102-fd/FV/OVMF.fd:/nix/store/kavdn6j03wfdwd2v1g4bnaw8bbrskrpb-OVMF-202102-fd/FV/OVMF_VARS.fd"
      ]
    '';
  };
}
