{ pkgs, ... }:

let
  wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;
in
{
  programs.chromium = {
    enable = true;
    package = wrappWithNixGL pkgs pkgs.ungoogled-chromium;
    # programs.chromium.extensions
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nixpkgs.config = {
     chromium = {
      enableWideVine = true;
      commandLineArgs = ''
        --enable-features=TouchpadOverscrollHistoryNavigation
      '';
        # --ignore-gpu-blocklist
        # --enable-zero-copy
        # --enable-features=VaapiVideoDecodeLinuxGL
      gnomeKeyringSupport = true;
      # ungoogled = true;
      # commandLineArgs = 
    };
  };
}
