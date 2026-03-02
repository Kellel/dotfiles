{ config, pkgs, lib, machineEmail, machineReposDir, machinePackages ? [ ], machineModules ? [ ], opencodeConfig ? null, ... }:

let
  opencodeConfigSource =
    if opencodeConfig != null
    then opencodeConfig
    else let
      configRepoFromEnv = builtins.getEnv "OPENCODE_CONFIG_REPO";
      fallbackConfigRepo = if configRepoFromEnv != "" then configRepoFromEnv else "${config.home.homeDirectory}/${machineReposDir}/opencode-config";
    in
      if (
        builtins.pathExists fallbackConfigRepo &&
        builtins.length (builtins.filter
          (entry: entry != ".git")
          (builtins.attrNames (builtins.readDir fallbackConfigRepo))) > 0
      )
      then fallbackConfigRepo
      else null;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kellen";
  home.homeDirectory = "/home/kellen";

  home.stateVersion = "25.11"; # Please read the comment before changing.

  nixpkgs = {
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
    pkgs._1password-cli
    pkgs._1password-gui
    pkgs.xsel
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.nerd-fonts.hack
    pkgs.gopls
    pkgs.pyright
    pkgs.ripgrep
    pkgs.nil
    pkgs.rustup
    pkgs.opencode
    pkgs.gnomeExtensions.user-themes
  ] ++ machinePackages;

  home.file = {
    ".themes/${config.gtk.theme.name}".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    GTK_THEME = "Everforest-Dark-B-LB:dark";
    RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";
  };

  home.sessionPath = [
    "$HOME/go/bin/"
    "/usr/local/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.nix-profile/bin"
  ];

  home.activation.ensureReposDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/${machineReposDir}"
  '';

  home.activation.rustupToolchain = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    RUSTUP_HOME="${config.home.homeDirectory}/.rustup"
    CARGO_HOME="${config.home.homeDirectory}/.cargo"
    export RUSTUP_HOME CARGO_HOME
    mkdir -p "$RUSTUP_HOME" "$CARGO_HOME"

    RUSTUP_BIN="${pkgs.rustup}/bin/rustup"

    STABLE_TOOLCHAIN="stable"

    if ! "$RUSTUP_BIN" run "$STABLE_TOOLCHAIN" rustc --version >/dev/null 2>&1; then
      "$RUSTUP_BIN" toolchain uninstall "$STABLE_TOOLCHAIN" || true
      "$RUSTUP_BIN" toolchain install "$STABLE_TOOLCHAIN"
    fi

    "$RUSTUP_BIN" default "$STABLE_TOOLCHAIN"

    for component in rustfmt clippy rust-src rust-analyzer; do
      if ! "$RUSTUP_BIN" component add --toolchain "$STABLE_TOOLCHAIN" "$component"; then
        if [ "$component" = "rust-analyzer" ]; then
          echo "warning: rust-analyzer not available for this toolchain; skipping."
          continue
        fi

        echo "error: failed to install rustup component '$component'" >&2
        exit 1
      fi
    done
  '';

  imports = [
    ./nvim.nix
    ./tmux.nix
  ] ++ machineModules;

  programs.git = {
    enable = true;
    settings = {
      branch = {
        sort = "-committerdate";
      };
      tag = {
        sort = "version:refname";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
      help = {
        autocorrect = "prompt";
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      user = {
        name = "Kellen Fox";
        email = machineEmail;
      };
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      cname="167;192;128"
      cdir="127;187;179"
      # leave this block alone
      code_color_name="\x1b[38;2;''${cname}m"
      code_color_dir="\x1b[38;2;''${cdir}m"
      code_color_reset='\x1b[0m'
      
      # leave this block alone
      c_name=$(printf "''${code_color_name}")
      c_dir=$(printf "''${code_color_dir}")
      c_rst=$(printf "''${code_color_reset}")
      export PS1='\[\e]0;\u@\h: \w\a\]''${debian_chroot:+($debian_chroot)}\[''${c_name}\]\u@\h\[''${c_rst}\]:\[''${c_dir}\]\w\[''${c_rst}\]\$ '
    '';
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
      font = "0xProto Nerd Font Mono 12";
      customCommand = "${pkgs.tmux}/bin/tmux";
      loginShell = true;
      colors = {
        foregroundColor = "#D3C6AA";
        backgroundColor = "#1E2326";
        boldColor = "#EBDBB2";
        palette = [
          "#1E2326"
          "#E67E80"
          "#A7C080"
          "#DBBC7F"
          "#7AA89F"
          "#D699B6"
          "#83C092"
          "#D3C6AA"
          "#4F585E"
          "#E69875"
          "#A7C080"
          "#DBBC7F"
          "#7AA89F"
          "#D699B6"
          "#9FD3A1"
          "#E6DBAF"
        ];
      };
      audibleBell = false;
    };
  };

  # Setup gnome theme
  gtk = {
    enable = true;
    theme = {
      package = pkgs.everforest;
      name = "Everforest-Dark-B-LB";
    };
    gtk4.extraConfig = {
      gtk-theme-name = "Everforest-Dark-B-LB";
      gtk-application-prefer-dark-theme = true;
    };
    gtk3.extraConfig = {
      gtk-theme-name = "Everforest-Dark-B-LB";
      gtk-application-prefer-dark-theme = true;
    };
  };
  xdg.configFile = {
    "gtk-3.0/gtk.css".source = pkgs.writeText "kellen-gtk3-titlebar-override.css" ''
      @import url("file://${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-3.0/gtk.css");

      headerbar,
      .background.csd headerbar,
      window.background.csd headerbar,
      .titlebar {
        background-color: #242d33;
        border-bottom-color: #3c4954;
      }

      box.vertical headerbar {
        background-color: #242d33;
      }
    '';
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = pkgs.writeText "kellen-gtk4-titlebar-override.css" ''
      @import url("file://${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css");

      headerbar,
      .background.csd headerbar,
      window.background.csd headerbar,
      .titlebar {
        background-color: #242d33;
        border-bottom-color: #3c4954;
      }

      headerbar {
        box-shadow: inset 0 -1px #3c4954;
      }

      headerbar:backdrop {
        background-color: #222b32;
      }
    '';
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  } // lib.optionalAttrs (opencodeConfigSource != null) {
    "opencode".source = opencodeConfigSource;
  };

  xdg.dataFile = {
    "themes/${config.gtk.theme.name}".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
    "gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com".source =
      "${pkgs.gnomeExtensions.user-themes}/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com";
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["caps:super"];
    };
    "org/gnome/desktop/interface" = {
      gtk-theme = "Everforest-Dark-B-LB";
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/wm/preferences" = {
      theme = "Everforest-Dark-B-LB";
      titlebar-font = "Adwaita Sans Bold 11";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Everforest-Dark-B-LB";
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
