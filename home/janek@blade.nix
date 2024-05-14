{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../modules/kitty.nix
    ../modules/zellij
    ../modules/hyprland.nix
    ../modules/chromium.nix
    ./common.nix
		inputs.nixvim.homeManagerModules.nixvim
  ];

	home = {
	  packages = with pkgs; [
	    nil
      jetbrains.jdk
      jetbrains.idea-ultimate
      jetbrains.clion
      jetbrains.rider
      jetbrains.rust-rover
	    nodePackages.vscode-langservers-extracted
      elmPackages.elm-language-server
	    elmPackages.lamdera
      elmPackages.elm-format
      elmPackages.elm
      omnisharp-roslyn

      discord
      discordo
      anki-bin
      # etcher # unsecure :<
      eww
      hyprpicker
      insync
      mattermost-desktop
      nwg-bar
      nwg-look
      pomodoro
      glow
      networkmanager-openvpn

      godot_4
      discord
	  ];
	};

  wayland.windowManager.hyprland.settings = {
	  monitor = [
  		"eDP-1,highres,0x1080,1.6 # buildin display"
  		"DP-1,preferred,0x0,auto"
  		"DP-3,preferred,1920x0,auto"
  		",preferred,auto,auto"
  	];
  };

  programs = {
    nixvim = {
      enable = true;
      colorschemes.gruvbox.enable = true;
      plugins.lightline.enable = true;
    };
  
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Janek Winkler";
      userEmail = "janekx21@gmail.de";
      extraConfig = {
        pull.rebase = true;
        submodule.recurse = true;
      };
      delta.enable = true;
    };
		
    lazygit = {
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
      };
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      plugins = [
        {
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
      initExtra = ''
        bindkey "^[[3~" delete-char
      '';
    };

    nushell = {
      enable = true;
      extraLogin = ''bindkey "^[[3~" delete-char'';
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

	  helix = {
      enable = true;
      defaultEditor = true;
      # package = inputs.helix.packages.x86_64-linux.default;
      settings = {
        theme = "gruvbox_dark_hard";
        editor = {
          auto-save = true;
          auto-format = true;
          bufferline = "multiple";
          cursorline = true;
          # color-modes = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "block";
          };

          lsp.display-messages = true;
          lsp.display-inlay-hints = true;

          indent-guides = {
            render = true;
            character = "▏";
            skip-levels = 1;
          };

          soft-wrap.enable = true;

          statusline = {
            left = ["mode" "spinner" "file-base-name" "read-only-indicator" "file-modification-indicator" "version-control"];
            right = ["diagnostics" "selections" "register" "position" "position-percentage" "file-encoding"];
            mode = {
              normal = "🖑";
              insert = "🖉";
              select = "☝";
            };
          };
        };
        keys.insert = {
          j = { k = "normal_mode"; };
          k = { j = "normal_mode"; };
        };

        keys.normal = {
          X = ["extend_line_up" "extend_to_line_bounds"];
          space = {
            l = "goto_next_buffer";
            h = "goto_previous_buffer";
            q = ":buffer-close";
          };
        };

        keys.select = {
          X = ["extend_line_up" "extend_to_line_bounds"];
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
          owl-ms-language-server = {
            command = "/home/janek/Git/owl-ms-language-server/target/debug/owl-ms-language-server";
          };
          ltex-ls = {
            command = "/opt/ltex-ls-15.2.0/bin/ltex-ls"; # TODO replace with nix
          };
          godot = {
            command = "nc";
            args = ["localhost" "6005"];
            language-id  = "gdscript";
          };
          typst-lsp.command = "typst-lsp";
          astro = {
            command = "astro-ls";
            args = ["--stdio"];
            config = {
              typescript = { 
                tsdk = "/usr/lib/node_modules/typescript/lib/";
                environment = "node";
              };
            };
          };
          mdx = {
            command = "mdx-language-server";
            args = ["--stdio"];
          };
          pest.command = "pest-language-server"; # TODO can i remove this?
          rust-analyzer.config = {
            check.command = "clippy";
            procMacro.enable = true;
            buildScripts.enable = true;
          };
        };
        language = [
          { name = "vue"; language-servers = ["vls"]; }
          {
            name = "gdscript";
            roots = ["project.godot"];
            language-servers = ["godot"];
          }
          {
            name = "elm";
            formatter = {command = "elm-format"; args = ["--stdin"]; };
            auto-format = true;
            indent = { tab-width = 4; unit = "    "; };
          }
          {
            name = "astro";
            scope = "source.astro";
            injection-regex = "astro";
            file-types = ["astro"];
            roots = ["package.json" "astro.config.mjs"];
            language-servers = ["astro"];
            auto-format = true;
            formatter = { command = "prettier"; args = ["--parser" "astro"]; };
          }
          {
            name = "mdx";
            language-servers = ["mdx" "ltex-ls"];
            scope = "source.mdx";
            # block-comment-tokens = { start = "<!--"; end = "-->" ; };
            indent = { tab-width = 2; unit = "  "; };
            injection-regex = "mdx";
            file-types = ["mdx"];
            roots = [];
            grammar = "markdown";
            auto-format = true;
            formatter = { command = "prettier"; args = ["--parser" "mdx"]; };
          }
          {
            name = "typst";
            scope = "text.typ";
            injection-regex = "typst";
            file-types = ["typ" "typst"];
            roots = ["main.typ"];
            language-servers = ["typst-lsp" "ltex-ls"];
            auto-format = true;
            formatter = { command = "typstfmt"; args = ["--stdout"]; };
            comment-token = "//";
            indent = { tab-width = 2; unit = "  "; };
          }
          {
            name = "javascript";
            formatter = { command = "npx"; args = ["prettier" "--parser" "babel"]; };
            auto-format = true;
          }
          {
            name = "pest";
            language-servers = [ "pest" ];
            scope = "text.pest";
            injection-regex = "pest";
            file-types = ["pest"];
            comment-token = "//";
            indent = { tab-width = 4; unit = "    "; };
            roots = [];
          }
          {
            name = "owl-ms";
            injection-regex = "owl-ms";
            scope = "text.omn";
            file-types = ["omn"];
            roots = [];
            language-servers = ["owl-ms-language-server"];
            comment-token = "//";
            indent = { tab-width = 4; unit = "    "; };
            grammar = "owl-ms"; # owl-ms default
          }
        ];
        grammar = [
          {
            name = "owl-ms";
            source = { git = "https://github.com/janekx21/tree-sitter-owl2-manchester-syntax"; rev = "a6e9be84affe8cd28b11c9cf103da4efcb047fa5"; };
            # source = { path = "/home/janek/Git/tree-sitter-owl2-manchester-syntax"; };
          }
        ];
      };
    };

    rofi = {
      enable = true;
      pass.enable = true;
    };

    fzf = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
			enableBashIntegration = true;
      nix-direnv.enable = true;
    };

		joshuto = {
			enable = true;
		};
  };
}
