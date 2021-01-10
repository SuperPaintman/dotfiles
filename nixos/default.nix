# See: https://nixos.org/nixos/options.html#

{ pkgs, lib, ... }@args:
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
  localPkgs = import ./pkgs args;

  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "63f299b3347aea183fc5088e4d6c4a193b334a41";
    ref = "release-20.09";
  };

  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

  dotfiles = getLocalOrRemote {
    local = /home/superpaintman/Projects/github.com/SuperPaintman/dotfiles;
    # TODO(SuperPaintman): fetch submodules.
    remote = builtins.fetchGit {
      url = "https://github.com/SuperPaintman/dotfiles";
    };
  };

  monitroid = getLocalOrRemote {
    local = /home/superpaintman/Projects/github.com/SuperPaintman/monitroid;
    # TODO(SuperPaintman): fetch submodules.
    remote = builtins.fetchGit {
      url = "https://github.com/SuperPaintman/monitroid";
    };
  };

  monitroidPkgs = pkgs.callPackage monitroid.path { };

  # Check if config file exists.
  vpnConfigs = builtins.filter (item: builtins.pathExists item.config) [
    { name = "server"; config = "/home/superpaintman/.openvpn/server.conf"; }
  ];
in
{
  # Imports.
  imports = [
    (import "${home-manager}/nixos")
    (import "${monitroid.path}/nixos")
  ];

  # Boot.
  boot.cleanTmpDir = true; # Delete all files in `/tmp` during boot.

  # TODO(SuperPaintman): it doesn't work with my wifi stick :(.
  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   rtl8812au # WiFi driver.
  # ];

  # Nix.
  nix.trustedUsers = [ "root" "@wheel" ];

  # Nix Packages.
  nixpkgs.config.allowUnfree = true;

  # Environment.
  environment.systemPackages = with pkgs; lib.lists.flatten [
    # Basic packages.
    coreutils
    wget
    curl
    atop
    htop
    git
    jq
    tmux
    zip
    unzip
    unrar
    xclip
    bind # dig
    wirelesstools
    lsof
    brightnessctl

    # Replacements for basic utils.
    exa # ls
    bat # cat
    fd # find

    # Shells.
    bash
    fish
    zsh

    # Editors.
    vim
    emacs
    (
      unstable.vscode-with-extensions.override {
        vscodeExtensions =
          let
            vscodeExtensionsFile = "${dotfiles.path}/vscode/extensions.nix";
          in
          if builtins.pathExists vscodeExtensionsFile
          then (import vscodeExtensionsFile args)
          else [ ];
      }
    )
    android-studio

    # Browsers.
    firefox
    (
      localPkgs.firefox-install-extensions {
        extensions =
          let
            firefoxExtensionsFile = "${dotfiles.path}/firefox/extensions.nix";
          in
          if builtins.pathExists firefoxExtensionsFile
          then (import firefoxExtensionsFile args)
          else [ ];
      }
    )
    chromium

    # Messengers.
    tdesktop # Telegram.
    discord
    skypeforlinux

    # Terminals.
    unstable.alacritty
    xst

    # Compilers, interpreters and dev packages.
    gnumake
    clang
    clang-tools
    gcc
    cmake
    llvm
    go
    gotools
    gopls
    godef
    go-outline
    gomodifytags
    impl
    nodejs
    python
    (
      python3.withPackages (
        packages: with packages; [
          telethon
        ]
      )
    )
    ruby
    localPkgs.rustup-openssl
    ghc
    stack
    haskellPackages.brittany
    elmPackages.elm
    dart
    flutter
    shfmt
    nixpkgs-fmt
    arduino

    # Docker.
    docker
    docker-compose

    # Server configuration utils.
    ansible
    terraform

    # Games.
    steam
    unstable.minecraft

    # Misc.
    (polybar.override { pulseSupport = true; })
    tldr # Simple man pages.
    lf # Terminal file manager.
    fzf # A command-line fuzzy finder written in Go.
    ripgrep # A utility that combines the usability of The Silver Searcher with the raw speed of grep.
    rofi # Window switcher, application launcher and dmenu replacement.
    feh # Image viewer.
    arandr # Visual front end for XRandR.
    pavucontrol # PulseAudio Volume Control.
    dbeaver # Universal SQL client.
    obs-studio # Streaming and recording program.
    audacity # Sound editor with graphical UI.
    scrot # A command-line screen capture utility.
    libnotify # A library that sends desktop notifications to a notification daemon.
    localPkgs._1password # 1Password command-line tool.
    localPkgs.gh # GitHub CLI tool.

    # Custom / mine.
    monitroidPkgs.monitroid # Machine stats.
  ];

  # Programs.
  programs = {
    fish.enable = true;
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
      package = pkgs.bluezFull;
    };
  };

  # Services.
  services.xserver = {
    enable = true;

    exportConfiguration = true;

    # Keyboard.
    layout = lib.concatStringsSep "," [ "us" "ru" ];
    xkbOptions = lib.concatStringsSep "," [
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
        ${xorg.xrdb}/bin/xrdb -load ~/.Xresources

        # Turn NumLock on.
        ${numlockx}/bin/numlockx on

        # Remove previous AwesomeWM state.
        ${coreutils}/bin/rm -f ~/.cache/awesome/state.json
      '';
    };

    desktopManager = {
      xterm.enable = false;
      plasma5.enable = true;
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

        awesomeWithLogs = pkgs.stdenv.mkDerivation rec {
          name = "awesome-with-logs";

          nativeBuildInputs = [ pkgs.makeWrapper ];

          phases = [ "installPhase" ];

          installPhase = ''
            mkdir -p $out/bin

            # Link all bin files.
            for b in ${pkgs.awesome}/bin/*; do
              if [ ! -f "$b" ]; then
                continue
              fi

              makeWrapper "$b" "$out/bin/$(basename $b)"
            done

            # Override awesome.
            rm -f "$out/bin/awesome"
            echo "#! ${pkgs.runtimeShell} -e" > "$out/bin/awesome"
            echo exec \"${pkgs.awesome}/bin/awesome\" '"$@"' \
              \>\> \"'${logfiles.stdout}'\" \
              2\>\> \"'${logfiles.stderr}'\" \
              >> "$out/bin/awesome"
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
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    shadow = true;
    shadowOffsets = [ (-15) (-10) ];
    shadowOpacity = 0.35;

    settings = {
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
    };
  };

  services.blueman.enable = true;

  services.openvpn.servers =
    # Merge servicers into one set.
    lib.mkMerge (
      builtins.map
        (
          item: {
            "${item.name}" = {
              config = "config ${item.config}";
              autoStart = false;
            };
          }
        )
        vpnConfigs
    );

  # Services: custom / mine.
  services.monitroid.enable = true;

  # Virtualisation.
  virtualisation.docker.enable = true;

  # Users.
  users.defaultUserShell = pkgs.zsh;

  users.users.superpaintman = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Security.
  security.sudo = {
    enable = true;

    # Always ask password.
    wheelNeedsPassword = true;

    extraConfig =
      let
        vpnServices = builtins.map (item: item.name) vpnConfigs;
        vpnCommands = [ "start" "stop" "restart" "status" ];
      in
      ''
        # No password for `nixos-rebuild`.
        # %wheel ALL=(ALL:ALL) NOPASSWD: /run/current-system/sw/bin/nixos-rebuild switch

        # VPN.
        ${lib.concatStringsSep "\n"
        (
          lib.lists.flatten
          (
            builtins.map
            (
              name: (
                [ "# openvpn-${name}.service." ]
                ++ (
                  builtins.map
                  (
                    command: "%wheel ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/systemctl ${command} openvpn-${name}.service"
                  )
                  vpnCommands
                )
              )
            )
            vpnServices
          )
        )}

        # Arduino.
        %wheel ALL=(ALL:ALL) NOPASSWD: ${pkgs.arduino}/bin/arduino
      '';
  };

  # Home Manager.
  home-manager.users = (
    let
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

            dotfilesFiles = callIfFunction (import dotfiles.path) {
              isMacOS = pkgs.stdenv.hostPlatform.isMacOS;
            };
          in
          if dotfiles.isLocal then (filesToSymlinks dotfilesFiles { }) else dotfilesFiles
        )
      ];

      # TODO(SuperPaintman): replace it with nix function in the dotfiles.
      firefoxFiles =
        let
          configPath = ".mozilla/firefox";
          profileName = "superpaintman";
          profilePath = "${profileName}.default";
          optionalFile = path: lib.optionalAttrs (builtins.pathExists "${dotfiles.path}/firefox/${path}") {
            "${configPath}/${profilePath}/${path}".source = "${dotfiles.path}/firefox/${path}";
          };
        in
        filesToSymlinks
          (
            {
              "${configPath}/profiles.ini".text = ''
                [Profile0]
                Name=default
                IsRelative=1
                Path=${profilePath}
                Default=1

                [General]
                StartWithLastProfile=1
                Version=2
              '';
            }
            // optionalFile "user.js"
            // optionalFile "chrome/userChrome.css"
            // optionalFile "chrome/userContent.css"
          )
          { };
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
          firefoxFiles
        ];
      };

      root = {
        home.file = lib.mkMerge [
          files
          firefoxFiles
        ];
      };
    }
  );

  # Fonts.
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fonts = with pkgs; [
      ubuntu_font_family
      dejavu_fonts
      fira-code
      font-awesome-ttf
      siji
      jetbrains-mono
      # helvetica-neue-lt-std
    ];

    fontconfig.defaultFonts = {
      sansSerif = [ "Ubuntu" ];
      monospace = [ "JetBrains Mono" ];
    };
  };
}
