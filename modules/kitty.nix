{ pkgs, lib, config, ... }:

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
      background_opacity = "0.90"; 
      background_blur = "16";
    };
  };
}
