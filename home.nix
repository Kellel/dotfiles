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
    overlays = [
      (self: super: { everforest = super.callPackage ./packages/everforest.nix {}; })
    ];
  };

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.htop
    pkgs.gnumake
    pkgs.tree
    pkgs.docker-compose
    pkgs.unzip
    pkgs.jq
    pkgs.sipcalc
    pkgs._1password
    pkgs._1password-gui
    pkgs.xsel
    pkgs.mtr
    pkgs.nerdfonts
    pkgs.gopls
    pkgs.rust-analyzer
    pkgs.ripgrep
    pkgs.nil
    pkgs.gnomeExtensions.user-themes
  ];

  home.file = {
  };

  home.sessionVariables = {
     EDITOR = "vim";
     GTK_THEME = "Everforest-Dark-B-LB";
  };

  imports = [
    ./vim.nix 
    ./nvim.nix
    ./tmux.nix
  ];

  programs.git = {
    enable = true;
    userName = "Kellen Fox";
    userEmail = "kellen@cloudflare.com";
    extraConfig = {
      pull = { rebase = true; };
      init = { defaultBranch = "main"; };
      core = { editor = "vim"; };
    };
  };

  programs.go = {
    enable = true;
  };

  programs.gnome-terminal = {
    enable = true;
    showMenubar = false;
    themeVariant = "dark";
    profile.cd120af7-97f1-4c36-9c0b-d6fbc48328a7 = {
      default = true;
      visibleName = "default setup";
      showScrollbar = false;
      font = "NotoMono Nerd Font 12";
      customCommand = "tmux";
      audibleBell = false;
    };
  };

  # Setup gnome theme
  gtk = {
    enable = true;
    theme = {
      package = pkgs.everforest;
      name="Everforest-Dark-B-LB";
    };
    gtk4.extraConfig = {
      gtk-theme-name="Everforest-Dark-B-LB";
      gtk-application-prefer-dark-theme = 0;
    };
    gtk3.extraConfig = {
      gtk-theme-name="Everforest-Dark-B-LB";
      gtk-application-prefer-dark-theme = 0;
    };
  };
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["caps:super"];
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
