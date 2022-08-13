{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.programs.vim;
in
{
  options.luksab.programs.vim.enable = mkEnableOption "Setup neovim";

  config = mkIf cfg.enable {

    xdg = {
      enable = true;
      configFile = {

        nvim = {
          source = ./config;
          recursive = true;
        };

      };
    };

    home.packages = with pkgs; [
      nerdfonts

      ripgrep
      lazygit
      nodejs
      fzf

      rnix-lsp
      fd
    ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withPython3 = true;

      plugins = with pkgs.vimPlugins; [
        impatient-nvim
        vim-clap

        vim-addon-nix
        nvim-lspconfig
        nvim-autopairs
        neorg
        rust-tools-nvim
        (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp-spell
        dashboard-nvim
        orgmode
        onedark-nvim
        catppuccin-nvim
        neoformat
        cmp-nvim-lsp
        barbar-nvim
        nvim-web-devicons
        vim-airline
        vim-airline-themes
        vim-markdown
        cmp-treesitter

        telescope-fzf-native-nvim
        nvim-fzf
        vim-better-whitespace
        vim-nix
      ];

      extraConfig = builtins.concatStringsSep "\n" [
        ''
          set termguicolors
          colorscheme onedark
          " colorscheme catppuccin 
          set cursorline
          let g:vim_markdown_folding_disabled = 1
          set clipboard+=unnamedplus
          " neovide settings
          set guifont=FiraCode\ Nerd\ Font:h7
          let g:neovide_cursor_vfx_mode = "railgun"

          luafile ${builtins.toString ./config/init_lua.lua}
        ''
      ];

    };

  };
}
