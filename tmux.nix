{ pkgs, ... }:
{
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
      set -g status-left '#[fg=#A7C080]#H '
      #set-window-option -g window-status-current-style bg=red
      setw -g monitor-activity on
      set -g visual-activity on
      set-option -g status-interval 3
      set-option -g automatic-rename on
      setw -g aggressive-resize on
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


      #### COLOR (everforest)
      # bg_dim #1E2326
      # bg0    #272E33
      # bg2    #374145
      # bg3    #414B50
      # bg4    #

      # default statusbar colors
      set-option -g status-style fg='#D3C6AA',bg='#1E2326' 
      set-option -g status-interval 1

      # default window title colors
      set-window-option -g window-status-style fg='#3A515D',bg=default #base0 and default

      # active window title colors
      set-window-option -g window-status-current-style fg='#E67E80',bg=default #orange and default

      # pane border
      set-option -g pane-border-style fg='#4F585E'
      set-option -g pane-active-border-style fg='#543A48'

      # message text
      set-option -g message-style fg='#D3C6AA',bg='#1E2326'

      # pane number display
      set-option -g display-panes-active-colour '#E67E80'
      set-option -g display-panes-colour '#3A515D'

      # clock
      set-window-option -g clock-mode-colour green #green

      # bell
      set-window-option -g window-status-bell-style fg=black,bg=red #base02, red
    '';
  };
}
