{ pkgs, lib, config, ... }:

# let
  # wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;
# in
{
  imports = [
    ../modules/kitty.nix
    ../modules/zellij
    ../modules/hyprland.nix
    ../modules/chromium.nix
    ../modules/waybar
    ./common.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # TODO systemd.user.services

  dconf.settings = {
    "org.gnome.desktop.input-sources" = {
      sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "de+neo_qwertz" ]) ];
    };
  };

  # services.random-background = {
  #   enable = true;
  #   imageDirectory = "%h/Pictures/Backgrounds";
  # };

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1,preferred,auto,1.333333"
      ",preferred,auto,auto"
    ];
  };

  home.packages = with pkgs; [
      # NIX
      cachix
      nix-tree
      nixgl.nixGLIntel
      
      # PC
      alacritty
      zip
      gzip
      firefox
      blender
      gimp
      inkscape-with-extensions
      keepassxc
      neofetch
      libreoffice
      obsidian
      # kitty-img
      # kitty-themes
      zsh-powerlevel10k
      htop
      nettools
      openssl
      wl-clipboard
      xclip
      kdiff3

      kdePackages.okular
      # teams
      # teams-for-linux
      # I know use teams inside of chromium. It works much better and has exelent pwa support.
      # minecraft
      p7zip
      cpulimit
      clamtk
      peek


      # IDE
      git
      vtm
      jetbrains.rider
      jetbrains.webstorm
      jetbrains.datagrip
      jetbrains.rust-rover
      lazydocker
      joshuto
      plantuml-c4
      rustup
      netcoredbg
      nodePackages.vls
      nil
      omnisharp-roslyn
      dotnet-sdk
      docker-compose
      marksman
      # gnome.gnome-boxes

      # FONTS
      roboto
      roboto-mono
      jetbrains-mono
      nerdfonts

      # nodejs
      # docker
      # mesa-demos
      # mesa
      # glxinfo

      # DESKTOP
      orchis-theme
      gnome.gnome-shell
      gnome-extension-manager
      gnome.gnome-shell-extensions
      gnome.gnome-tweaks
      gnome.gnome-clocks
      # gnome.gnome-control-center
      gnome.nautilus

      # Versions do not line up :<
      # gnomeExtensions.extension-list
      # gnomeExtensions.just-perfection
      # gnomeExtensions.panel-corners
      # gnomeExtensions.blur-my-shell

      # gnomeExtensions.thinkpad-thermal
      # gnomeExtensions.thanatophobia
      # gnomeExtensions.user-themes
      
      # Virtualization
      docker
      # VIRTUALBOX
      # linuxKernel.packages.linux_6_2.virtualbox
  ];

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   package = lib.mkForce (lib.makeOverridable ({enableXWayland, enableNvidiaPatches}: wrappWithNixGL pkgs pkgs.hyprland) {enableXWayland = true; enableNvidiaPatches = false;});
  #   settings = {
  #     monitor = [
  #       ",preferred,auto,auto"
  #       "eDP-1,preferred,auto,1"
  #     ];
  #     general = {
  #       border_size = 2;
  #       "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
  #       "col.inactive_border" = "rgba(595959aa)";
  #     };
  #     input = {
  #       kb_layout = "de";
  #       kb_variant = "neo_qwertz";
  #       follow_mouse = 1;
  #     };
  #     decoration = {
  #       rounding = 16;
  #       drop_shadow = true;
  #       shadow_range = 4;
  #       shadow_render_power = 3;
  #       shadow_offset = "0 5";
  #       "col.shadow" = "rgba(00000099)";
  #     };
  #     animations = {
  #       enabled = true;
  #       # TODO get more specific
  #     };
  #     "$mod" = "SUPER";
  #     bind = [
  #       "$mod, W, exec, firefox"
  #       "$mod, Q, exec, gnome-terminal"
  #       "$mod, E, exec, nautilus"
  #       "$mod, R, exec, rofi --show drun"
  #       "$mod, C, killactive,"
  #       "$mod, V, togglefloating,"
  #     ];
  #     bindm = [
  #       # mouse movements
  #       "$mod, mouse:272, movewindow"
  #       "$mod, mouse:273, resizewindow"
  #       "$mod ALT, mouse:272, resizewindow"
  #     ];
  #   };
  # };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # this does not exsist
  # users.users.janek = {
  #   shell = pkgs.zsh;
  # };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/janek/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
    BROWSER = "chromium";
	  ELECTRON_OZONE_PLATFORM_HINT = "auto";
     # TERMINAL = "alacritty"; todo
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # https://github.com/nix-community/home-manager/issues/1439
  xdg = {
    enable = true;
    mime.enable=true;
    # mimeApps = {
    #   enable = true;
    #   defaultApplications = {
    #     "text/plain" = ["Helix.desktop"];
    #   };
    # };
  };

  targets.genericLinux.enable=true;

  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Dark";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Tela-dark";
      package = pkgs.tela-icon-theme;
    };
  };
	xdg.configFile = {
	  "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
	  "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
	  "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
	};


  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Janek Winkler";
      userEmail = "janek.winkler@bridgefield.de";
      extraConfig = {
        pull.rebase = false;
        submodule.recurse = true;
      };
      delta.enable = true;
      # difftastic.enable = true;
    };
  };
  programs.helix = {
    enable = true;
    defaultEditor = true;
    # todo needs nightly defaultEditor = true;
    settings = {
      theme = "gruvbox_dark_hard";
      editor = {
        lsp.display-messages = true;
        lsp.display-inlay-hints = true;
        auto-save = true;
        auto-format = true;
        cursorline = true;
        bufferline = "multiple";
        color-modes = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "block";
        };
        indent-guides = {
          render = true;
          character = "▏";
          skip-levels = 1;
        };
        soft-wrap.enable = true;
        statusline = {
          left = ["mode" "spinner" "file-base-name" "read-only-indicator" "file-modification-indicator" "version-control"];
          right = ["diagnostics" "selections" "register" "position" "position-percentage" "file-encoding"];
        };
      };
      keys.insert = {
        j = { k = "normal_mode"; };
        k = { j = "normal_mode"; };
      };

      keys.normal = {
        X = ["extend_line_up" "extend_to_line_bounds"];
        A-x = ["extend_to_line_bounds"];
        space = {
          l = ":buffer-next";
          h = ":buffer-previous";
          q = ":buffer-close";
        };
      };

      keys.select = {
        X = ["extend_line_up" "extend_to_line_bounds"];
        A-x = ["extend_to_line_bounds"];
      };
    };
    languages = {
      language-server = {
        vls = {
          command = "vls";
        };
        omnisharp = {
          timeout = 10000;
        };
      };
      language = [
        { name = "vue"; language-servers = ["vls"]; }
      ];
    };
    # languages = {
    #   c-sharp = {
    #     language-server = {
    #       command = "OmniSharp";
    #       args = ["-lsp"];
    #       timeout=10000;
    #     };
    #   };
    # };
  };
    # programs.kitty = {
    #   enable = true;
    #   font = {
    #     size = 15;
    #     name = "JetBrainsMono Nerd Font";
    #   };
    #   shellIntegration.enableZshIntegration = true;
    #   package = wrappWithNixGL pkgs pkgs.kitty;
    #   # theme = "Material Dark";
    #   # settings = {
    #     # linux_display_server = "x11";
    #   # };
    # };

  programs.bash = {
    enable = true;
    bashrcExtra = "exec zsh";
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    plugins = [{
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];
    envExtra = "bindkey \"^[[3~\" delete-char";
  };

  programs.nushell = {
    enable = true;
    # shellAliases = config.home.shellAliases;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.zoxide.enableNushellIntegration = true;

  # TODO
  # programs.starship = {
  #   enable = true;
  #   enableZshIntegration
  # };

  programs.lazygit ={
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
        border = "rounded";
      };
      git = {
        parseEmoji = true;
        paging.pager = "delta --dark --paging=never";
      };
      os.copyToClipboardCmd = "xclip";
    };
  };

  programs.joshuto = {
    enable = true;
    settings = {
      # xdg_open = true; # did not get this to work with helix
      preview.preview_script = "~/.config/home-manager/joshuto/preview_file.sh";
    };
  };

  programs.rofi = {
    enable = true;
  };

  programs = {
    direnv.enable = true;
    direnv.enableZshIntegration = true;
    direnv.enableBashIntegration = true;
    direnv.nix-direnv.enable = true;
    direnv.enableNushellIntegration = true;
  };

	xdg.configFile.".ideavimrc".text = 
  #idevimrc
  ''
    " General
    set scrolloff=5
    set linenumber
    set showmode
    set showcmd
    set visualbell
    set clipboard+=unnamed

    " Search settings 
    set ignorecase
    set smartcase
    set incsearch
    set hlsearch

    let mapleader = " "

    " Plugins
    set surround
    set sneak
    set nerdtree
    set easymotion " Needs a intellij plugin AceJump and IdeaVim-EasyMotion
    set notimeout
    set which-key

    " witch-key config
    let g:WhichKeyDesc_display = "<leader>d Display options"

    let g:WhichKeyDesc_zen_mode = "<leader>dz Toggle Zen mode"
    let g:WhichKeyDesc_df_mode = "<leader>dd Toggle Distraction-Free mode"
    let g:WhichKeyDesc_fullscreen = "<leader>df Toggle full screen"
    " let g:WhichKeyDesc_<identifier> = "<keybinding> <helptext>"

    " Key mapping
    inoremap jk <Esc>

    "" Tab navigation
    nnoremap <leader>l :tabnext<CR>
    nnoremap <leader>h :tabprev<CR>\

    "" Comment lines
    map <C-c> <action>(CommentByLineComment)
  '';
}
