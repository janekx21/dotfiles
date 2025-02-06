{
  description = "Nix configs of Janek";
  nixConfig = {
    extra-substituters = [ "https://cache.nixos.org/" ];
    # extra-trusted-public-keys =
    #   [ "jost-s.cachix.org-1:MJaFoUZA8dZ+v4zO8dLQd9D154zUWBwOUtEw0W26GL8=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl.url = "github:guibou/nixGL";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      # inputs.helix.follows = "nixpkgs";
    };

    zjstatus = {
      url = "github:dj95/zjstatus";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, nixgl, helix, zjstatus, ... }:
    let
      system = "x86_64-linux";

      zjstatusOverlay = (final: prev: {
        zjstatus = zjstatus.packages.${prev.system}.default;
      });
      
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay helix.overlays.default zjstatusOverlay ];
  			config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "electron-19.1.9"
        ];
      };
    in {
      homeConfigurations = import ./home {
        inherit inputs pkgs home-manager;
      };

      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # TODO rework
              home-manager.users.janek = import (./home + "/janek@nixos.nix");
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };

              # import ./home {
                      # inherit inputs pkgs home-manager;
                    # };
              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
      };
    };
}
