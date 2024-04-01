{
  description = "Nix configs of Janek";


  nixConfig = {
    extra-substituters = [ "https://cache.nixos.org/" ];
    extra-trusted-public-keys =
      [ "jost-s.cachix.org-1:MJaFoUZA8dZ+v4zO8dLQd9D154zUWBwOUtEw0W26GL8=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
      inputs.helix.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, nixgl, helix, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay helix.overlays.default ];
  			config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "electron-19.1.9"
        ];
      };
    in {
      homeConfigurations = import ./home {
        inherit inputs pkgs home-manager;
      };
    };
}
