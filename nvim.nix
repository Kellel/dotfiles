{
  pkgs,
  lib,
  ...
}: let
  fromGitHub = rev: ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
        rev = rev;
      };
    };
	unstable = import <unstable> {
		config = {
			allowUnfree = true;
		};
	};
in {
  #main
  programs = {
    neovim = {
      plugins = [
        ## Colorscheme
        #{
        #  plugin = pkgs.vimPlugins.tokyonight-nvim;
        #  config = ''
        #    require("tokyonight").setup({
        #    })
        #    vim.cmd[[colorscheme tokyonight-storm]]
        #  '';
        #  type = "lua";
        #}
        #{
        #  plugin = pkgs.vimPlugins.vim-colors-solarized;
        #  config = ''
        #  colorscheme solarized
        #  '';
        #}
        {
          plugin = pkgs.vimPlugins.everforest;
          config = ''
		  let g:everforest_transparent_background = 2
          colorscheme everforest
          '';
        }

        ## Treesitter
        {
          plugin = pkgs.vimPlugins.nvim-treesitter;
          config = builtins.readFile nvim-config/setup/treesitter.lua;
          type = "lua";
        }

        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
        pkgs.vimPlugins.nvim-treesitter-textobjects

        {
          plugin = pkgs.vimPlugins.nvim-lspconfig;
          config = builtins.readFile nvim-config/setup/lspconfig.lua;
          type = "lua";
        }

        ## Telescope
        {
          plugin = pkgs.vimPlugins.telescope-nvim;
          config = builtins.readFile nvim-config/setup/telescope.lua;
          type = "lua";
        }
        pkgs.vimPlugins.telescope-fzf-native-nvim

        ## cmp
        {
          plugin = pkgs.vimPlugins.nvim-cmp;
          config = builtins.readFile nvim-config/setup/cmp.lua;
          type = "lua";
        }
        pkgs.vimPlugins.cmp-nvim-lsp
        pkgs.vimPlugins.cmp-buffer
        pkgs.vimPlugins.cmp-cmdline
        pkgs.vimPlugins.cmp_luasnip
		pkgs.vimPlugins.plenary-nvim

		{
          plugin = pkgs.vimPlugins.windsurf-nvim;
		  config = builtins.readFile nvim-config/setup/windsurf.lua;
		  type = "lua";
		}

        # Adds pictograms to stuff 
        pkgs.vimPlugins.lspkind-nvim

        # luasnip
        {
          plugin = pkgs.vimPlugins.luasnip;
          config = builtins.readFile nvim-config/setup/luasnip.lua;
          type = "lua";
        }

        {
          plugin = pkgs.vimPlugins.neo-tree-nvim;
          config = builtins.readFile nvim-config/setup/neo-tree.lua;
          type = "lua";
        }

        pkgs.vimPlugins.fugitive

		{
			plugin = unstable.vimPlugins.go-nvim;
			config = builtins.readFile nvim-config/setup/go-nvim.lua;
			type = "lua";
		}

		{
			plugin = pkgs.vimPlugins.lualine-nvim;
			config = builtins.readFile nvim-config/setup/lualine.lua;
			type = "lua";
		}

      ];

      extraLuaConfig = ''
        ${builtins.readFile nvim-config/mappings.lua}
        ${builtins.readFile nvim-config/options.lua}
      '';
      enable = true;
      viAlias = false;
      vimAlias = true;
    };
  };
}
