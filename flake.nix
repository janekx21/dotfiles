{
  description = "Nix configs of Janek";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl.url = "github:guibou/nixGL";
  };

  outputs = inputs @ { nixpkgs, home-manager, nixgl, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
  			config.allowUnfree = true;
      };
    in {
      homeConfigurations = import ./home {
        inherit inputs pkgs home-manager;
      };
    };
}
