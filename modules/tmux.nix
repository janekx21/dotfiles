{ inputs, config, pkgs, lib, ... }:
let
  tmux-nerd-font-window-name = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-nerd-font-window-name";
      version = "2.1.2";
      src = pkgs.fetchFromGitHub {
        owner = "joshmedeski";
        repo = "tmux-nerd-font-window-name";
        rev = "2f5131f01b6cc052069211f6dce02c3fec564da2";
        sha256 = "sha256-bnlOAfdBv5Rg4z1hu1jtdx5oZ6kAZE40K4zqLxmyYQE=";
      };
    };
in
{
  programs.tmux = {
    enable = true;
    tmuxp.enable = true;

    aggressiveResize = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    prefix = "M-e";
    terminal = "xterm-kitty";

    extraConfig = 
    # conf
    ''
      # reload config file (change file location to your the tmux.conf you want to use)
      bind R source-file ~/.config/tmux/tmux.conf

      # switch panes using Alt-arrow without prefix
      # bind -n M-Left select-pane -L
      # bind -n M-Right select-pane -R
      # bind -n M-Up select-pane -U
      # bind -n M-Down select-pane -D
      bind -n M-h previous-window
      bind -n M-l next-window

      # DESIGN TWEAKS

      # don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # clock mode
      setw -g clock-mode-colour colour1

      # copy mode
      setw -g mode-style 'fg=colour1 bg=colour18 bold'

      # pane borders
      set -g pane-border-style 'fg=colour1'
      set -g pane-active-border-style 'fg=colour3'

      # statusbar
      set -g status-position top
      set -g status-justify left
      set -g status-style 'fg=colour2'
      set -g status-left ' 󰼁 '
      set -g status-right '#(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD) '
      set -g status-right-length 50
      set -g status-left-length 10

      setw -g window-status-current-style 'bold'
      setw -g window-status-current-format '#[bg=default,fg=colour2]#[fg=colour0,bg=colour2] #W #[bg=default,fg=colour2]'

      setw -g window-status-style 'fg=colour2 dim'
      setw -g window-status-format ' #[fg=colour7]#W '

      setw -g window-status-bell-style 'fg=colour2 bg=colour1 bold'

      # messages
      set -g message-style 'fg=colour2 bg=colour0 bold'
    '';

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.tmux-fzf
      # tmuxPlugins.pass
      # tmuxPlugins.fingers # Sieht ser cool aus
      {
        plugin = (tmuxPlugins.resurrect.overrideAttrs (oldAttrs: {
          preFixup = (oldAttrs.preFixup or "") + ''
            rm $out/share/tmux-plugins/resurrect/run_tests
            rm $out/share/tmux-plugins/resurrect/tests/run_tests_in_isolation
            rm $out/share/tmux-plugins/resurrect/tests/helpers/helpers.sh
            # clean up other dangling symlinks here...
          '';
        }));
        extraConfig = 
        #const
        ''
          set -g @resurrect-strategy-nvim 'session'
          # Set Programs to restore
          set -g @resurrect-processes '"~hx->hx *" "~lazygit" "~joshuto" "~lazydocker" "~dotnet watch->dotnet watch *" "~npm run serve->npm run serve" "~typst watch->typst watch *"'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig =
        #conf
        ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10' # minutes
        '';
      }
      # { # returns 127
        # plugin = tmux-nerd-font-window-name;
      # }
    ];
  };
}
