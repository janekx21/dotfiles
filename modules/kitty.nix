{ pkgs, lib, ... }:

let
  wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;
in
{
  programs.kitty = {
    enable = true;
    font = {
      size = 12;
      name = "JetBrainsMono Nerd Font"; # TODO use nix pkgs
    };
    shellIntegration.enableZshIntegration = true;
    package = wrappWithNixGL {inherit pkgs; pkg = pkgs.kitty;};
    theme = "Gruvbox Dark Hard";
    settings = {
      background_opacity = "0.95";
      background_blur = "16";
    };
  };
}
