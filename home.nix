{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kellen";
  home.homeDirectory = "/home/kellen";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.htop
    pkgs.gnumake
    pkgs.vim
  ];

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
     EDITOR = "vim";
  };

  programs.git = {
    enable = true;
    userName = "Kellen Fox";
    userEmail = "kellen@cloudflare.com";
    extraConfig = {
      pull = { rebase = true; };
      init = { defaultBranch = "main"; };
    };
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      'VundleVim/Vundle.vim'
      'tpope/vim-fugitive'
      'lifepillar/vim-solarized8'
      'ervandew/supertab'
      'fatih/vim-go'
      'egonschiele/salt-vim'
      'LnL7/vim-nix'
    ]; 
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
      
      " Set shift width to 4 spaces.
      set shiftwidth=4
      
      " Set tab width to 4 columns.
      set tabstop=4
      
      " Use space characters instead of tabs.
      set expandtab
      
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
      
      "set termguicolors
      "colorscheme solarized8_flat
      "let g:solarized_termtrans = 1
      
      "enable Omni
      set omnifunc=syntaxcomplete#Complete
      
      " vim-go settings
      let g:go_auto_type_info = 1
      let g:go_doc_popup_window = 1
      let g:go_fmt_command = "goimports"
      let g:go_metalinter_autosave = 1
    '';
     
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
