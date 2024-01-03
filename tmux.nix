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
}
