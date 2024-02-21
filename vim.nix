{ pkgs, ... }:
{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-fugitive
      vim-solarized8
      supertab
      vim-go
      salt-vim
      rust-vim
      vim-nix
    ];
    settings = {
      expandtab = true;
      tabstop = 4;
      shiftwidth = 4;
    };
    extraConfig = ''
      set nocompatible

      " syntax stuff
      filetype off
      syntax on
      set background=dark

      " numbers and crosshairs
      set number
      set cursorline
      set cursorcolumn

      " Do not save backup files.
      set nobackup

      " Do not let cursor scroll below or above N number of lines when scrolling.
      set scrolloff=10

      " Do not wrap lines. Allow long lines to extend as far as the line goes.
      set nowrap

      " While searching though a file incrementally highlight matching characters as you type.
      set incsearch

      " Ignore capital letters during search.
      set ignorecase

      " Override the ignorecase option if searching for capital letters.
      " This will allow you to search specifically for capital letters.
      set smartcase

      " Show partial command you type in the last line of the screen.
      set showcmd

      " Show the mode you are on the last line.
      set showmode

      " Show matching words during a search.
      set showmatch

      " Use highlighting when doing a search.
      set hlsearch

      " Set the commands to save in history default number is 20.
      set history=1000

      " Enable auto completion menu after pressing TAB.
      set wildmenu

      " Make wildmenu behave like similar to Bash completion.
      set wildmode=list:longest

      " There are certain files that we would never want to edit with Vim.
      " Wildmenu will ignore files with these extensions.
      set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

      filetype plugin indent on    " required

      " system clipboard
      set clipboard=unnamedplus

      set termguicolors
      colorscheme solarized8_flat
      let g:solarized_termtrans = 1

      "enable Omni
      set omnifunc=syntaxcomplete#Complete

      " vim-go settings
      let g:go_auto_type_info = 1
      let g:go_doc_popup_window = 1
      let g:go_fmt_command = "goimports"
      let g:go_fmt_autosave = 1
      let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
      let g:go_metalinter_autosave = 1
      let g:go_highlight_types = 1
      let g:go_highlight_functions = 1
      let g:go_highlight_fields = 1

      " rust-vim settings
      let g:rustfmt_autosave = 1
    '';
  };
}
