{ pkgs, ... }:

let
  wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;
in
{
  programs.chromium = {
    enable = true;
    package = wrappWithNixGL pkgs pkgs.chromium;
    # programs.chromium.extensions
  };

  nixpkgs.config = {
     chromium = {
      enableWideVine = true;
      # gnomeKeyringSupport = true;
      # ungoogled = true;
      # commandLineArgs = 
    };
  };
}
