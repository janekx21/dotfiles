{ config, pkgs, lib, ... }:
{
	home = {
		username = "janek";
	  homeDirectory = "/home/janek";
	  stateVersion = "23.05";

	  packages = with pkgs; [
	    nil
	    cachix
	    nodePackages.vscode-langservers-extracted
	    elmPackages.lamdera
	    nixgl.nixGLIntel
	    nixgl.nixVulkanIntel
	  ];

	  shellAliases = {
	    edit = "~/Git/dotfiles/edit.sh";
      cd = "z";
	    ".." = "z ..";
	    hx = "helix";
	    ide = "zellij --layout=helix-ide";
	    lg = "lazygit";
	  };

	  sessionVariables = {
	    # EDITOR = "helix"; this is set with helix module
	  };
	};

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;

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
      enableAutosuggestions = true;
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
      settings = {
        theme = "gruvbox_dark_hard";
        editor = {
          auto-save = true;
          auto-format = true;
          bufferline = "multiple";
          cursorline = true;
          color-modes = true;
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
            # source = { git = "https://github.com/janekx21/tree-sitter-owl2-manchester-syntax", rev = "a55d6bdd3104cd64bfe7178395aa6a139b5632a9" }
            source = { path = "/home/janek/Git/tree-sitter-owl2-manchester-syntax"; };
          }
        ];
      };
    };

    kitty = {
      enable = true;
      font = {
        size = 12;
        name = "JetBrainsMono Nerd Font"; # TODO use nix pkgs
      };
      theme = "Gruvbox Dark Hard";
      shellIntegration.enableZshIntegration = true;
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

    zellij = {
      enable = true;
    };
		
		joshuto = {
			enable = true;
		};
   
	  chromium.package =
			let
		    wrapped-chromium =
		      lib.makeOverridable
		      ({commandLineArgs}:
		        pkgs.runCommand "wrapped-chromium" {
		          buildInputs = [pkgs.makeWrapper];
		          chromium = pkgs.ungoogled-chromium;
		        } ''
		          mkdir -p "$out/bin"
		          makeWrapper "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel" "$out/bin/chromium" \
		            --argv0 chromium \
		            --add-flags "$chromium/bin/chromium" \
		            --add-flags ${lib.escapeShellArg commandLineArgs}
		          ln -s "$out/bin/chromium" "$out/bin/chromium-browser"
		          ln -s "$chromium/share" "$out/share"
		        '')
		      {commandLineArgs = [];};
		  in
	    lib.mkForce wrapped-chromium;
  };
}
