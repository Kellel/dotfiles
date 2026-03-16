{ config, pkgs, lib, machineEmail, machineReposDir, machinePackages ? [ ], machineModules ? [ ], opencodeConfig ? null, ... }:

let
  opencodeConfigFiltered = if opencodeConfig != null then
    lib.cleanSourceWith {
      src = opencodeConfig;
      filter = path: type:
        let name = baseNameOf path; in
        name != ".git" && name != "node_modules" && name != "bun.lock" && name != "package.json" && name != ".gitignore";
    }
  else null;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kellen";
  home.homeDirectory = "/home/kellen";

  home.stateVersion = "25.11"; # Please read the comment before changing.

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

  home.sessionVariables = {
    EDITOR = "nvim";
    GTK_THEME = "${config.gtk.theme.name}:dark";
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

  home.activation.opencodeConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.optionalString (opencodeConfigFiltered != null) ''
      OPENCODE_CONFIG_DIR="${config.home.homeDirectory}/.config/opencode"
      OPENCODE_CONFIG_SRC="${opencodeConfigFiltered}"

      mkdir -p "$OPENCODE_CONFIG_DIR"

      # Copy config files from Nix store, overwriting existing config files
      ${pkgs.rsync}/bin/rsync -a --delete \
        --exclude='node_modules' \
        --exclude='bun.lock' \
        --exclude='package.json' \
        "$OPENCODE_CONFIG_SRC/" "$OPENCODE_CONFIG_DIR/"

      # Ensure the copied files are writable
      chmod -R u+w "$OPENCODE_CONFIG_DIR"
    ''
  );

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
      package = pkgs.colloid-gtk-theme.override {
        colorVariants = [ "dark" ];
        tweaks = [ "everforest" "rimless" ];
      };
      name = "Colloid-Dark-Everforest";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
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
      gtk-theme = config.gtk.theme.name;
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/wm/preferences" = {
      theme = config.gtk.theme.name;
      titlebar-font = "Adwaita Sans Bold 11";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = config.gtk.theme.name;
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
