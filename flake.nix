{
  description = "Nix configs of Janek";

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

    # helix = {
    #   url = "github:helix-editor/helix";
    #   # inputs.helix.follows = "nixpkgs";
    # };
  };

  outputs = inputs @ { nixpkgs, home-manager, nixgl, helix, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
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
