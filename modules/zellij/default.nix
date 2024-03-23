{ pkgs, lib, ... }:
{
  programs.zellij = {
    enable = true;
    # enableZshIntegration = true;
    # settings managed by xdg.configFile.zellij
  };
  xdg.configFile.zellij = {
    source = ./dot_config;
    recursive = true;
  };
}
