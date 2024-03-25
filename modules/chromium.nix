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

  home.packages = [
    pkgs.widevine-cdm
  ];
}
