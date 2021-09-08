# Full example:
# https://tech.ingolf-wagner.de/nixos/krops/

let

  # Basic krops setup
  krops = builtins.fetchGit { url = "https://cgit.krebsco.de/krops/"; };
  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" { };

  source = name:
    lib.evalSource [{

      # Copy over the whole repo. By default nixos-rebuild will use the
      # currents system hostname to lookup the right nixos configuration in
      # `nixosConfigurations` from flake.nix
      machine-config.file = toString ./.;
    }];

  command = targetPath: ''
    nix-shell -p git --run '
      nixos-rebuild switch -v --show-trace --flake ${targetPath}/machine-config || \
        nixos-rebuild switch -v --show-trace --flake ${targetPath}/machine-config
    '
  '';

  # Convenience function to define machines with connection parameters and
  # configuration source
  createHost = name: target:
    pkgs.krops.writeCommand "deploy-${name}" {
      inherit command;
      source = source name;
      target = target;
    };

in rec {

  # Define deployments

  # Run with (e.g.):
  # nix-build ./krops.nix -A all && ./result
  # nix-build ./krops.nix -A desktop && ./result
  # nix-build ./krops.nix -A servers && ./result
  #
  # nix-build ./krops.nix -A arm && ./result
  # nix-build ./krops.nix -A majaArm && ./result
  # nix-build ./krops.nix -A pi4b && ./result
  # nix-build ./krops.nix -A laptop && ./result

  # Individual machines
  laptop = createHost "laptop" "root@laptop";

  arm = createHost "arm" "root@ocp.luksab.de";

  majaArm = createHost "majaArm" "root@val.luksab.de";

  pi4b = createHost "pi4b" "root@192.168.178.55";

  pi4b2 = createHost "pi4b2" "root@192.168.178.35";

  # Groups
  all = pkgs.writeScript "deploy-all" (lib.concatStringsSep "\n" [ laptop arm pi4b pi4b2 majaArm ]);

  desktops = pkgs.writeScript "deploy-desktops" (lib.concatStringsSep "\n" [ laptop pi4b2 ]);

  servers = pkgs.writeScript "deploy-servers" (lib.concatStringsSep "\n" [ arm majaArm pi4b ]);
}
