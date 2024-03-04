{ inputs, pkgs, home-manager, ... }:
let
	mkHome = {username, hostname}: home-manager.lib.homeManagerConfiguration {
			inherit pkgs;

      extraSpecialArgs = {
        inherit inputs;
      };
			
			modules = [
				(./. + "/${username}@${hostname}.nix")
			];
		};
in
{
	"janek@blade" = mkHome {
		username = "janek";
		hostname = "blade";
	};
}

