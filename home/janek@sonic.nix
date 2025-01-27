{ pkgs, lib, config, ... }:

# let
  # wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;
# in
{
  imports = [
    ../modules/kitty.nix
    ../modules/chromium.nix
    ../modules/tmux.nix
    ../modules/jetbrains.nix
    ./common.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # TODO systemd.user.services

  # dconf.settings = {
  #   "org.gnome.desktop.input-sources" = {
  #     sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "de+neo_qwertz" ]) ];
  #   };
  # };

  # services.random-background = {
  #   enable = true;
  #   imageDirectory = "%h/Pictures/Backgrounds";
  # };

  # wayland.windowManager.hyprland.settings = {
  #   monitor = [
  #     "eDP-1,preferred,auto,1.333333"
  #     ",preferred,auto,auto"
  #   ];
  # };

  home.packages = with pkgs; [
      # NIX
      cachix
      nix-tree
      nixgl.nixGLIntel
      
      # PC
      # alacritty
      zip
      gzip
      # firefox
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

      # kdePackages.okular
      # kdePackages.spectacle
      # teams
      # teams-for-linux
      # I know use teams inside of chromium. It works much better and has exelent pwa support.
      # minecraft
      p7zip
      cpulimit
      clamtk
      peek

      mariadb

      # IDE
      git
      vtm
      jetbrains.rider
      jetbrains.webstorm
      jetbrains.datagrip
      jetbrains.rust-rover
      # vscode
      lazydocker
      joshuto
      plantuml-c4
      rustup
      netcoredbg
      # nodePackages.vls replaced by official lsp
      vue-language-server
      nodePackages.prettier
      nil
      omnisharp-roslyn
      dotnet-sdk_8
      docker-compose
      marksman
      # gnome.gnome-boxes

      # FONTS
      roboto
      roboto-mono
      jetbrains-mono

      # nodejs
      # docker
      # mesa-demos
      # mesa
      # glxinfo

      # DESKTOP
      # orchis-theme
      # gnome.gnome-shell
      # gnome-extension-manager
      # gnome.gnome-shell-extensions
      # gnome.gnome-tweaks
      # gnome.gnome-clocks
      # # gnome.gnome-control-center
      # gnome.nautilus

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
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);


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

  home.sessionVariables = {
    BROWSER = "chromium";
	  ELECTRON_OZONE_PLATFORM_HINT = "auto";
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
        # vls = {
        #   command = "vls";
        # };
        # vue-language-server = {
        #   command = "vue-language-server";
        # };
        omnisharp = {
          timeout = 10000;
        };
      };

      language = [
        {
          name = "vue";
          # language-servers = ["vue-language-server"];
          formatter = { command = "prettier"; args = ["--parser" "vue"]; };
        }
      ];
    };
  };

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
    envExtra = ''
      bindkey "^[[3~" delete-char
      export PATH="$PATH:/home/janek/.dotnet/tools"
    '';
  };

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
      preview.preview_script = "~/.config/home-manager/joshuto/preview_file.sh";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}
