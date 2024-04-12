{ config, pkgs, lib, ... }:
# let
#   wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;
# in
{
  imports = [
    ../modules/kitty.nix 
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

	home = {
		username = "janek";
	  homeDirectory = "/home/janek";
	  stateVersion = "23.05";

	  packages = with pkgs; [
	    cachix
	    nixgl.nixGLIntel
	    nixgl.nixVulkanIntel
	    nil
	  ];

	  shellAliases = {
      ll = "ls -l";
	    change = "~/Git/dotfiles/change.bash";
      cd = "z";
	    ".." = "z ..";
	    ide = "zellij --layout=helix-ide";
	    lg = "lazygit";
      ld = "lazydocker";
      dc = "docker-compose";
	  };
	};

  fonts.fontconfig.enable = true;

  home.keyboard = {
    layout = "de";
    variant = "neo_qwertz";
  };

  programs = {
    home-manager.enable = true;
  };
}

