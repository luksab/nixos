{
  description = "My main system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.11";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    mayniklas.url = "github:mayniklas/nixos";
    mayniklas.inputs.nixpkgs.follows = "nixpkgs";
    mayniklas.inputs.nixpkgs-unstable.follows = "nixpkgs";
    mayniklas.inputs.home-manager.follows = "home-manager";
  };

  outputs = { self, ... }@inputs:
    with inputs;
    {

      overlays = {

        # Expose overlay to flake outputs, to allow using it from other flakes.
        default = final: prev: (import ./overlays inputs) final prev;

        master = final: prev: {
          master = import nixpkgs-master {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };

        stable = final: prev: {
          stable = import nixpkgs-stable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixpkgs-fmt;

      # Output all modules in ./modules to flake. Modules should be in
      # individual subdirectories and contain a default.nix file
      nixosModules = builtins.listToAttrs
        (map
          (x: {
            name = x;
            value = import (./modules + "/${x}");
          })
          (builtins.attrNames (builtins.readDir ./modules)))

      //

      {
        home-manager = { config, pkgs, lib, ... }: {
          imports = [
            home-manager.nixosModules.home-manager
            ./home-manager/home.nix
            ./home-manager/home-server.nix
          ];
          home-manager.users.lukas.imports = [{
            nixpkgs.overlays = [
              self.overlays.default
              self.overlays.master
              self.overlays.stable
            ];
          }];
        };
      };

      # Each subdirectory in ./machins is a host. Add them all to
      # nixosConfiguratons. Host configurations need a file called
      # configuration.nix that will be read first
      nixosConfigurations = builtins.listToAttrs
        (map
          (x: {
            name = x;
            value = nixpkgs.lib.nixosSystem {

              # Make inputs and the flake itself accessible as module parameters.
              # Technically, adding the inputs is redundant as they can be also
              # accessed with flake-self.inputs.X, but adding them individually
              # allows to only pass what is needed to each module.
              specialArgs = { flake-self = self; } // inputs;

              system = "x86_64-linux";

              modules = [
                (./machines/x86 + "/${x}/configuration.nix")
                { imports = builtins.attrValues self.nixosModules; }
                mayniklas.nixosModules.yubikey
                mayniklas.nixosModules.virtualisation
                mayniklas.nixosModules.options
              ];
            };
          })
          (builtins.attrNames (builtins.readDir ./machines/x86)))
      // builtins.listToAttrs (map
        (x: {
          name = x;
          value = nixpkgs.lib.nixosSystem {

            # Make inputs and the flake itself accessible as module parameters.
            # Technically, adding the inputs is redundant as they can be also
            # accessed with flake-self.inputs.X, but adding them individually
            # allows to only pass what is needed to each module.
            specialArgs = { flake-self = self; } // inputs;

            system = "aarch64-linux";

            modules = [
              (./machines/aarch64 + "/${x}/configuration.nix")
              { imports = builtins.attrValues self.nixosModules; }
              mayniklas.nixosModules.yubikey
              mayniklas.nixosModules.virtualisation
              mayniklas.nixosModules.options
            ];
          };
        })
        (builtins.attrNames (builtins.readDir ./machines/aarch64)));
    } //

    # (flake-utils.lib.eachSystem [ "aarch64-linux" "i686-linux" "x86_64-linux" ])
    (flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ]) (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays =
            [ self.overlays.default self.overlays.master self.overlays.stable ];
          config = {
            allowUnsupportedSystem = true;
            allowUnfree = true;
          };
        };
      in
      rec {

        packages = flake-utils.lib.flattenTree {
          larbs_scripts = pkgs.larbs_scripts;
          #   anki-bin = pkgs.anki-bin;
          #   darknet = pkgs.darknet;
          #   plex = pkgs.plex;
          #   plexRaw = pkgs.plexRaw;
          #   tautulli = pkgs.tautulli;
        };

        apps = {
          # Allow custom packages to be run using `nix run`
          #   anki-bin = flake-utils.lib.mkApp { drv = packages.anki-bin; };
          #   darknet = flake-utils.lib.mkApp { drv = packages.darknet; };
          #   plex = flake-utils.lib.mkApp { drv = packages.plex; };
          #   plexRaw = flake-utils.lib.mkApp { drv = packages.plexRaw; };
          #   tautulli = flake-utils.lib.mkApp { drv = packages.tautulli; };
        };
      });
}
