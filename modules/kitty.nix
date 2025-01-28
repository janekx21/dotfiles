{ pkgs, lib, config, ... }:

let
  wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;
in
{
  programs.kitty = {
    enable = true;
    font = {
      size = 12;
      name = "JetBrainsMono"; # TODO use nix pkgs
    };
    shellIntegration.enableZshIntegration = true;
    package = wrappWithNixGL {inherit pkgs; pkg = pkgs.kitty;};
    theme = "Gruvbox Dark Hard";
    settings = {
      background_opacity = if config.wayland.windowManager.hyprland.enable then "0.90" else "1.00"; 
      # background_opacity = "0.90";
      background_blur = "16";
    };
  };
}
