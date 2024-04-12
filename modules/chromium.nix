{ pkgs, lib, config, ... }:

let
  wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;
  commandLineArgs = [
    "--enable-features=TouchpadOverscrollHistoryNavigation"
    "--enable-logging=stderr"
    "--ignore-gpu-blocklist"      
  ];
in
{
  programs.chromium = {
    enable = true;
    # package = wrappWithNixGL pkgs pkgs.ungoogled-chromium;
    package = wrappWithNixGL {inherit pkgs; pkg = pkgs.ungoogled-chromium;args = lib.concatStringsSep " " commandLineArgs;};
    # commandLineArgs = [
    #   "--enable-features=TouchpadOverscrollHistoryNavigation"
    #   "--enable-logging=stderr"
    #   "--ignore-gpu-blocklist"      
    # ];
    # programs.chromium.extensions
# [
#   { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
#   {
#     id = "dcpihecpambacapedldabdbpakmachpb";
#     updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
#   }
#   {
#     id = "aaaaaaaaaabbbbbbbbbbcccccccccc";
#     crxPath = "/home/share/extension.crx";
#     version = "1.0";
#   }
# ]
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  nixpkgs.config = {
     chromium = {
      enableWideVine = true;
        # --ignore-gpu-blocklist
        # --enable-zero-copy
        # --enable-features=VaapiVideoDecodeLinuxGL
      # gnomeKeyringSupport = true;
      # ungoogled = true;
      # commandLineArgs = 
    };
  };
}
