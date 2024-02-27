{ pkgs, lib, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  home.username = "janek";
  home.homeDirectory = "/home/janek";
# This value determines the Home Manager release that your configuration is # compatible with. This helps avoid breakage when a new Home Manager release # introduces backwards incompatible changes.  # # You should not change this value, even if you update Home Manager. If you do # want to update the value, then make sure to first check the Home Manager # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  home.keyboard = {
    layout = "de";
    variant = "neo-qwertz";
  };

  dconf.settings = {
    "org.gnome.desktop.input-sources" = {
      sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "de+neo_qwertz" ]) ];
    };
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  
  home.packages = with pkgs; [
      # NIX
      cachix
      nix-tree
      
      # PC
      alacritty
      zip
      gzip
      firefox
      blender
      ungoogled-chromium
      gimp-with-plugins
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
      # teams
      # teams-for-linux
      # I know use teams inside of chromium. It works much better and has exelent pwa support.
      minecraft
      p7zip
      cpulimit
      memtest86plus
      memtest86-efi


      # IDE
      git
      zellij
      vtm
      jetbrains.rider
      jetbrains.webstorm
      jetbrains.datagrip
      jetbrains.rust-rover
      lazydocker
      joshuto
      plantuml-c4
      dotnet-sdk
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
      gnome-extension-manager
      gnome.gnome-shell-extensions
      gnome.gnome-tweaks
      gnome.gnome-clocks
      gnomeExtensions.extension-list
      # gnomeExtensions.thinkpad-thermal
      # gnomeExtensions.thanatophobia
      # gnomeExtensions.user-themes
      
      # VIRTUALBOX
      # linuxKernel.packages.linux_6_2.virtualbox
      nixgl.nixGLIntel
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };
      "$mod" = "SUPER";
      bind = [
        "$mod, W, exec, firefox"
        "$mod, Q, exec, nixGL kitty"
      ];
      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
    };
  };

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
     EDITOR="hx";
     BROWSER = "firefox";
     # TERMINAL = "alacritty"; todo
  };

  # comment

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


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
    programs.kitty = {
      enable = true;
      font = {
        size = 15;
        name = "JetBrainsMono Nerd Font";
      };
      shellIntegration.enableZshIntegration = true;
      # theme = "Material Dark";
      # settings = {
        # linux_display_server = "x11";
      # };
    };

    programs.bash = {
      enable = true;
      bashrcExtra = "exec zsh";
    };

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
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
      shellAliases = {
        ll = "ls -l";
        update = "home-manager switch";
        change = "hx ~/.config/home-manager/home.nix";
        dc = "docker-compose";
        ld = "lazydocker";
        lg = "lazygit";
      };
      envExtra = "bindkey \"^[[3~\" delete-char";
    };

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

    programs.zellij = {
      enable = true;
      # enableZshIntegration = true;
      # todo
      settings = {
        copy_command = "xclip";
        pane_frames = false;
      };
    };

    programs.joshuto = {
      enable = true;
      settings = {
        # xdg_open = true; # did not get this to work with helix
        preview.preview_script = "~/.config/home-manager/joshuto/preview_file.sh";
      };
    };

    programs = {
      direnv.enable = true;
      direnv.enableZshIntegration = true;
      direnv.enableBashIntegration = true;
      direnv.nix-direnv.enable = true;
    };
}
