{ pkgs, ... }:
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

  xdg.configFile."zellij/layouts/helix-ide.kdl".text = ''
    layout {
        default_tab_template {
            pane size=1 borderless=true {
                // plugin location="zellij:compact-bar"
                plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                    // #[fg=#000000,bg=#ff9001,bold] {session} #[]  
                    format_left  "{mode} {tabs}"
                    format_right "{command_git_branch}"
                    format_space ""

                    border_enabled  "false"
                    border_char     "─"
                    border_format   "#[fg=#6C7086]{char}"
                    border_position "top"

                    hide_frame_for_single_pane "true"

                    mode_normal  "[#fg=#a0a0a0] 󰼁 "
                    mode_pane  "#[bg=blue] 󰼁 "
                    mode_tab  "#[bg=green] 󰼁 "
                    mode_rename_pane  "#[bg=blue] 󰼁 rename pane "
                    mode_rename_tab  "#[bg=green] 󰼁 rename tab "
                    mode_session  "#[bg=red] 󰼁 "
                    mode_default_to_mode "normal"

                    tab_normal   "#[fg=#a0a0a0] {name} "
                    tab_active   "#[fg=#7cdd1a]#[fg=#000000,bg=#7cdd1a,bold] {name} #[fg=#7cdd1a]"

                    // TODO maybe this? {git rev-parse --abbrev-ref HEAD; git show --stat | tail -1;}
                    command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                    command_git_branch_format      "#[fg=#7cdd1a] {stdout} "
                    command_git_branch_interval    "10"
                    command_git_branch_rendermode  "static"

                    datetime        "#[fg=#a0a0a0,bold] {format} "
                    datetime_format "%A, %d %b %Y %H:%M"
                    datetime_timezone "Europe/Berlin"
                }
            }
            children
        }
        tab name="helix" focus=true {
            pane command="hx" {
                args "."
            }
        }
        tab name="terminal"
        tab name="lazygit" {
            pane command="lazygit"
        }
        tab name="joshuto" {
            pane command="joshuto"
        }
        tab name="lazydocker" {
            pane command="lazydocker"
        }
    }
  '';
}
