{ pkgs, lib, config, ... }:

let
  wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;
in
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

  services.home-manager.autoUpgrade.enable = true;
  services.home-manager.autoUpgrade.frequency = "weekly";

  home.packages = with pkgs; [
      # NIX
      cachix
      nix-tree
      nixgl.nixGLIntel
      
      # PC
      zip
      gzip
      blender
      gimp
      inkscape-with-extensions
      keepassxc
      neofetch
      libreoffice
      obsidian
      zsh-powerlevel10k
      htop
      nettools
      openssl
      xclip
      kdiff3

      p7zip
      cpulimit
      clamtk
      peek

      # IDE
      git
      vtm # cool terminal multiplexer
      lazydocker
      joshuto
      plantuml-c4
      rustup
      netcoredbg
      vue-language-server
      nodePackages.prettier
      nil
      omnisharp-roslyn
      dotnet-sdk_8
      docker-compose
      marksman
      nodejs

      elmPackages.elm
      elmPackages.elm-language-server
      elmPackages.elm-format

      # FONTS
      roboto
      roboto-mono
      jetbrains-mono

      # Virtualisation
      docker
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

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
