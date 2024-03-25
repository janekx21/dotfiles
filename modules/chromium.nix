{ pkgs, lib, ... }:

let
  wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;
in
{
  programs.chromium.enable = {
    enable = true;
    package = wrappWithNixGL pkgs pkgs.ungoogled-chromium;
    # programs.chromium.extensions
  };
}
