# See: https://nixos.org/nixos/options.html#

{ pkgs, lib, config, ... }@args:
let
  getLocalOrRemote = { local, remote }:
    # Use a local copy if we have one.
    if builtins.pathExists local
    then rec {
      path = local;
      isLocal = true;
      isRemote = !isLocal;
    }
    else rec {
      path = remote;
      isLocal = false;
      isRemote = !isLocal;
    };
in
let
  localPkgs = pkgs.callPackage ./pkgs { };

  # themes = pkgs.callPackage ../themes { };

  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "f21d9167782c086a33ad53e2311854a8f13c281e";
    ref = "release-25.05";
  };

  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

  # monitroid = getLocalOrRemote {
  #   local = /home/superpaintman/Projects/github.com/SuperPaintman/monitroid;
  #   # TODO(SuperPaintman): fetch submodules.
  #   remote = builtins.fetchGit {
  #     url = "https://github.com/SuperPaintman/monitroid";
  #   };
  # };
  #
  # monitroidPkgs = pkgs.callPackage monitroid.path { };
in
{
  # Imports.
  imports = lib.lists.flatten [
    # EXPERIMENTAL
    ../modules
    # / EXPERIMENTAL

    # ./modules/services/network-filesystems/rclone.nix
    (import "${home-manager}/nixos")
    # (import "${monitroid.path}/nixos")
    (if builtins.pathExists ../secrets then ../secrets/nixos else [ ])
  ];

  # EXPERIMENTAL
  modules = {
    users = {
      users.superpaintman = { };
    };

    programs = {
      alacritty.enable = true;
      ansible.enable = true;
      bat.enable = true;
      essential.enable = true;
      essential.desktop.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      git.enable = true;
      lf.enable = true;
      neovim.enable = true;
      rofi.enable = true;
      tmux.enable = true;
    };

    development = {
      cc.enable = true;
      dart.enable = false;
      dart.flutter.enable = false;
      essential.enable = true;
      go = {
        enable = true;
        package = pkgs.go_latest; 
      };
      javascript.enable = true;
      lua.enable = true;
      protobuf.enable = true;
      python.enable = true;
      ruby.enable = false;
      rust.enable = true;
      zig.enable = true;
    };

    shell = {
      bash.enable = true;
      zsh.enable = true;
    };
  };
  # / EXPERIMENTAL

  # Boot.
  boot.tmp.cleanOnBoot = true; # Delete all files in `/tmp` during boot.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # TODO(SuperPaintman): it doesn't work with my wifi stick :(.
  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   rtl8812au # WiFi driver.
  # ];

  # Nix.
  nix.settings.trusted-users = [ "root" "@wheel" ];

  # Nix Packages.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import ../overlays/lib.nix)
    (import ../overlays/pkgs.nix)
    (import ../overlays/ports.nix)
    (import ../overlays/patches.nix)
    (self: super: {
      unstable = unstable;
      local = localPkgs;
      home-manager = pkgs.callPackage home-manager { };
    })
  ];

  # Environment.
  environment.systemPackages = with pkgs; lib.lists.flatten [
    # Basic packages.
    # coreutils
    # wget
    # curl
    # atop
    # htop
    btop
    # git
    # jq
    zip
    unzip
    unrar
    # xclip
    bind # dig
    wirelesstools
    # lsof
    brightnessctl
    upower

    # Replacements for basic utils.
    # eza # ls
    # bat # cat
    # fd # find

    # Shells.
    bash
    # fish
    zsh

    # Editors.
    # vim
    # neovim
    # neovide
    (
      vscode-with-extensions.override {
        vscodeExtensions = import ../vscode/extensions.nix args;
      }
    )
    # android-studio

    # Browsers.
    # firefox
    # (
    #   localPkgs.firefox-install-extensions.override {
    #     firefox = firefox;
    #     extensions = import ../firefox/extensions.nix args;
    #   }
    # )
    chromium

    # Messengers.
    telegram-desktop # Telegram.
    discord
    # skypeforlinux

    # Compilers, interpreters and dev packages.
    # gnumake
    # clang
    # clang-tools
    # gcc
    # cmake
    # llvm
    # ccls
    # go
    # gotools
    # gopls
    # godef
    # go-outline
    # gomodifytags
    # impl
    # delve
    # nodejs
    # python
    # (
    #   python3.withPackages (
    #     packages: with packages; [
    #       telethon
    #     ]
    #   )
    # )
    # ruby
    # localPkgs.rustup-openssl
    # rust-analyzer
    # ghc
    # stack
    # haskellPackages.brittany
    # elmPackages.elm
    # dart
    # flutter
    shfmt
    nixpkgs-fmt
    # rnix-lsp
    terraform-lsp
    # arduino
    # nodePackages.prettier
    # protobuf
    # protoc-gen-go
    # protoc-gen-go-grpc
    # zig

    # Docker.
    docker
    docker-compose

    # Vagrant
    # vagrant

    # Server configuration utils.
    # ansible
    terraform
    awscli2 # Unified tool to manage your AWS services.

    # Games.
    steam

    # Misc.
    entr # Run arbitrary commands when files change.
    tldr # Simple man pages.
    # ripgrep # A utility that combines the usability of The Silver Searcher with the raw speed of grep.
    feh # Image viewer.
    arandr # Visual front end for XRandR.
    pavucontrol # PulseAudio Volume Control.
    dbeaver-bin # Universal SQL client.
    obs-studio # Streaming and recording program.
    audacity # Sound editor with graphical UI.
    scrot # A command-line screen capture utility.
    libnotify # A library that sends desktop notifications to a notification daemon.
    anki-bin # Spaced repetition flashcard program
    (localPkgs.anki-desktop.override { anki-bin = anki-bin; }) # Spaced repetition flashcard program.
    wally-cli # CLI flashing tool for ZSA Moonlander.
    prusa-slicer # Prusa Slicer.
    openscad # 3D parametric model compiler.
    freecad

    # Icons.
    paper-icon-theme

    # Custom / mine.
    # monitroidPkgs.monitroid # Machine stats.

    # Scripts.
    (writeShellScriptBin "restart-setup-commands" ''
      ${config.services.xserver.displayManager.setupCommands}
    '')
    (writeShellScriptBin "restart-session-commands" ''
      ${config.services.xserver.displayManager.sessionCommands}
    '')

    # Local bins.
    extras
    # godot_4
    # gdsdecomp
    # spine
    pico8
  ];

  # Programs.
  programs = {
    # fish.enable = true;
    zsh.enable = true;
  };

  # Hardware.
  hardware = {
    pulseaudio = {
      support32Bit = true;
      package = pkgs.pulseaudioFull;
    };

    opengl = {
      driSupport32Bit = true;
    };

    bluetooth = {
      package = pkgs.bluez;
    };

    printers = {
      ensureDefaultPrinter = "PastaPrinter";
      ensurePrinters = [
        {
          name = "PastaPrinter";
          description = "Xerox(R) B230 Printer";
          deviceUri = "ipp://192.168.16.57:631/ipp/print";
          model = "drv:///sample.drv/generic.ppd";
          ppdOptions = {
            PageSize = "A4";
            ColorModel = "Gray";
          };
        }
      ];
    };
  };

  # Services.
  services.xserver = {
    enable = true;

    exportConfiguration = true;

    # Keyboard.
    xkb.layout = lib.concatStringsSep "," [ "us" "ru" ];
    xkb.options = lib.concatStringsSep "," [
      "caps:escape" # Caps Lock as Escape.
      "grp:alt_shift_toggle" # Toggle layout.
      "grp_led:caps" # Use led as indicator.
    ];

    # Display, desktop and window managers.
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
      };

      sessionCommands = with pkgs; ''
        # Load X resources.
        if [ -f ~/.Xresources ]; then
          ${xorg.xrdb}/bin/xrdb -load ~/.Xresources
        fi

        # Turn NumLock on.
        ${numlockx}/bin/numlockx on

        # Load Xmodmap config.
        if [ -f ~/.Xmodmap ]; then
          ${xorg.xmodmap}/bin/xmodmap ~/.Xmodmap
        fi

        # Remove previous AwesomeWM state.
        ${coreutils}/bin/rm -f ~/.cache/awesome/state.json
      '';
    };

    desktopManager = {
      xterm.enable = false;
      plasma6.enable = true;
    };

    windowManager.awesome =
      let
        # By default AwesomeWM doesn't write logs.
        #
        # We add writing logs into the files.
        #
        # See: https://awesomewm.org/apidoc/documentation/90-FAQ.md.html
        logfiles = {
          stdout = "$HOME/.cache/awesome/stdout";
          stderr = "$HOME/.cache/awesome/stderr";
        };

        awesome = pkgs.awesome.override {
          lua = pkgs.luajit;
        };

        awesomeWithLogs = pkgs.stdenv.mkDerivation rec {
          name = "awesome-with-logs";

          nativeBuildInputs = [ pkgs.makeWrapper ];

          phases = [ "installPhase" ];

          installPhase = ''
            mkdir -p $out/bin

            # Link all bin files.
            for b in ${awesome}/bin/*; do
              if [ ! -f "$b" ]; then
                continue
              fi

              makeWrapper "$b" "$out/bin/$(basename $b)"
            done

            # Override awesome.
            rm -f "$out/bin/awesome"

            cat <<'EOF' > "$out/bin/awesome"
            #! ${pkgs.runtimeShell} -e

            if [ ! -d "$HOME/.cache/awesome" ]; then
              (umask 077 && mkdir "$HOME/.cache/awesome")
            fi
            chmod 0700 "$HOME/.cache/awesome"

            exec ${awesome}/bin/awesome "$@" \
              >> "${logfiles.stdout}" \
              2>> "${logfiles.stderr}"
            EOF

            chmod +x "$out/bin/awesome"
          '';
        };
      in
      {
        enable = true;

        package = awesomeWithLogs;
      };
  };

  # See: https://github.com/yshui/picom/blob/master/picom.sample.conf
  # See: https://wiki.archlinux.org/index.php/Picom
  # See: `xprop`.
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    opacityRules = [
      "90:window_type = 'notification' && class_g = 'awesome'"
    ];

    shadow = true;
    shadowOffsets = [ (-10) (-10) ];
    shadowOpacity = 0.22;

    settings = {
      blur-background = true;
      blur-kern = "7x7box";
      blur-strength = 320;
      blur-background-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
      ];

      # The blur radius for shadows, in pixels. (defaults to 12)
      # shadow-radius = 12
      shadow-radius = 12;

      # Unredirect all windows if a full-screen opaque window is detected,
      # to maximize performance for full-screen windows. Known to cause
      # flickering when redirecting/unredirecting windows.
      #
      # NOTE(SuperPaintman): if true it makes glitches on the second screen.
      unredir-if-possible = false;

      # GLX backend: Avoid using stencil buffer, useful if you don't have a
      # stencil buffer. Might cause incorrect opacity when rendering
      # transparent content (but never practically happened) and may not work
      # with blur-background. My tests show a 15% performance boost.
      # Recommended.
      glx-no-stencil = true;

      # Use X Sync fence to sync clients' draw calls, to make sure all draw
      # calls are finished before picom starts drawing. Needed on
      # nvidia-drivers with GLX backend for some users.
      xrender-sync-fence = true;
    };
  };

  services.blueman.enable = true;

  services.upower.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint ];
  };

  services.udev.packages = [
    # Add rules for Moonlander.
    # See: https://github.com/zsa/wally/wiki/Linux-install
    localPkgs.zsa-udev-rules

    # Add rules for Android Devices.
    pkgs.android-udev-rules
  ];

  # Services: custom / mine.
  # services.monitroid.enable = true;

  # services.rclone = {
  #   enable = true;
  #
  #   users.superpaintman = {
  #     mounts.google-drive = {
  #       remote = "Google Drive";
  #       mountPoint = "~/GoogleDrive";
  #     };
  #   };
  # };

  # Virtualisation.
  virtualisation.docker = {
    enable = true;
    daemon = {
      settings = {
        insecure-registries = [ "gitea.local" ];
      };
    };
  };
  virtualisation.libvirtd.enable = true;

  # Users.
  users.defaultUserShell = pkgs.zsh;

  users.users.superpaintman = {
    isNormalUser = true;
    description = "Aleksandr Krivoshchekov";
    uid = 1000;
    extraGroups = [ "wheel" "docker" "libvirtd" "plugdev" ];
    shell = pkgs.zsh;
  };

  # Add group for ZSA Moonlander.
  # See: https://github.com/zsa/wally/wiki/Linux-install
  users.groups.plugdev = { };

  # Security.
  security.sudo = {
    enable = true;

    # Always ask password.
    wheelNeedsPassword = true;

    extraConfig =
      ''
        # nmcli - device wifi.
        ${lib.concatMapStringsSep "\n"
          (command: ''
            %wheel ALL=(ALL:ALL) NOPASSWD: ${pkgs.networkmanager}/bin/nmcli dev wifi ${command}
            %wheel ALL=(ALL:ALL) NOPASSWD: ${pkgs.networkmanager}/bin/nmcli dev wifi ${command} *
            %wheel ALL=(ALL:ALL) NOPASSWD: ${pkgs.networkmanager}/bin/nmcli device wifi ${command}
            %wheel ALL=(ALL:ALL) NOPASSWD: ${pkgs.networkmanager}/bin/nmcli device wifi ${command} *
          '')
          [ "list" "connect" "rescan" ]
        }
      '';
  };

  # Home Manager.
  home-manager.users = (
    let
      mkSymlink = src: pkgs.runCommand "symlink" { } ''
        ln -s ${src} $out
      '';

      mkDonfilesSymlinks = files: pkgs.runCommand "symlink-dotfiles" { } ''
        ${lib.concatStringsSep "\n"
        (
          lib.mapAttrsToList
          (
            name: file: ''
              # ${name}.
              mkdir -p $out/$(dirname ${name})
              ln -s ${toString file.source} $out/${name}
            ''
          )
          files
        )}
      '';

      filesToSymlinks = files: { ignore ? [ ] }:
        let
          checkIsSymlink = n: v:
            (lib.hasAttr "source" v) && (lib.all (re: builtins.match re n == null) ignore);

          groups = {
            symlinks = lib.filterAttrs (n: v: checkIsSymlink n v) files;
            rest = lib.filterAttrs (n: v: !(checkIsSymlink n v)) files;
          };

          replaceWithSymlinks = files:
            let
              symlinks = mkDonfilesSymlinks files;
            in
            lib.mapAttrs
              (
                n: v: {
                  source = "${symlinks}/${n}";
                }
              )
              files;
        in
        (replaceWithSymlinks groups.symlinks) // groups.rest;

      files = lib.mkMerge [
        # Make symlinks to local dotfiles instead of nix derivatives to
        # enable local editing.
        (
          let
            # Support old dotfiles format.
            callIfFunction = f: args: if builtins.isFunction f then (f args) else f;

            dotfilesFiles = callIfFunction (import ../.) {
              isLinux = pkgs.stdenv.hostPlatform.isLinux;
              isMacOS = pkgs.stdenv.hostPlatform.isMacOS;
            };
          in
          filesToSymlinks dotfilesFiles { }
        )
      ];
    in
    {
      superpaintman = {
        # Or pick manually.
        # lib.getAttrs [
        #   # Dotfiles.
        #   ".dotfiles"
        # ] files;

        home.file = lib.mkMerge [
          files
          # batFiles
        ];

        home.stateVersion = "25.05";
      };

      root = {
        home.file = lib.mkMerge [
          files
          # batFiles
        ];

        home.stateVersion = "25.05";
      };
    }
  );

  # Fonts.
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;

    packages = with pkgs; [
      ubuntu_font_family
      dejavu_fonts
      fira-code
      font-awesome
      siji
      jetbrains-mono
      # helvetica-neue-lt-std
      nerd-fonts.jetbrains-mono
    ];

    fontconfig.defaultFonts = {
      sansSerif = [ "Ubuntu" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
