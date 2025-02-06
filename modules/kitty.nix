{ pkgs, lib, config, ... }:

let
  # wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;
in
{
  programs.kitty = {
    enable = true;
    font = {
      size = 12;
      name = "MonaspiceAr NF"; # TODO make this a nerdfont again
      # package = pkgs.nerd-fonts.fira-code;
    };
    shellIntegration.enableZshIntegration = true;
    # package = wrappWithNixGL {inherit pkgs; pkg = pkgs.kitty;};
    themeFile = "GruvboxMaterialDarkHard";
    settings = {
      background_opacity = if config.wayland.windowManager.hyprland.enable then "0.90" else "1.00"; 
      background_blur = "16";
    };
  };
}
