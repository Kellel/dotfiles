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
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-fugitive
      vim-solarized8
      supertab
      vim-go
      salt-vim
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
      
      set termguicolors
      colorscheme solarized8_flat
      let g:solarized_termtrans = 1
      
      "enable Omni
      set omnifunc=syntaxcomplete#Complete
      
      " vim-go settings
      let g:go_auto_type_info = 1
      let g:go_doc_popup_window = 1
      let g:go_fmt_command = "goimports"
      let g:go_metalinter_autosave = 1
    '';
     
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256-color";
    historyLimit = 100000;
    plugins = with pkgs.tmuxPlugins; [
      yank
      sensible
    ];
    extraConfig = ''
      bind c new-window -c "#{pane_current_path}"
      set-option -g base-index 1
      set-window-option -g pane-base-index 1
      set-option -sg escape-time 50
      set -g status-left-length 20
      set -g status-left '#[fg=green]#H '
      #set-window-option -g window-status-current-style bg=red
      setw -g monitor-activity on
      set -g visual-activity on
      set-option -g status-interval 3
      set-option -g automatic-rename on
      setw -g aggressive-resize on
      set-option -g history-limit 7000
      setw -g mode-keys vi
      unbind [
      bind Escape copy-mode
      unbind p
      bind p paste-buffer
      set -g mouse on
      set -g default-terminal "xterm-color"
      set-option -ga terminal-overrides ",xterm-color:Tc:smcup@:rmcup@"
      set -g set-clipboard on
      set -g @yank_selection 'clipboard'
      set -g @yank_selection_mouse 'clipboard'
      
      
      #### COLOUR (Solarized dark)
      
      # default statusbar colors
      set-option -g status-style fg=yellow,bg=black #yellow and base02
      
      # default window title colors
      set-window-option -g window-status-style fg=blue,bright,bg=default #base0 and default
      #set-window-option -g window-status-style dim
      
      # active window title colors
      set-window-option -g window-status-current-style fg=red,bright,bg=default #orange and default
      #set-window-option -g window-status-current-style bright
      
      # pane border
      set-option -g pane-border-style bg=default,fg=blue #base02
      set-option -g pane-active-border-style fg=green,bright #base01
      
      # message text
      set-option -g message-style fg=red,bright,bg=black #orange and base01
      
      # pane number display
      set-option -g display-panes-active-colour orange
      set-option -g display-panes-colour blue #blue
      
      # clock
      set-window-option -g clock-mode-colour green #green
      
      # bell
      set-window-option -g window-status-bell-style fg=black,bg=red #base02, red
    '';
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
