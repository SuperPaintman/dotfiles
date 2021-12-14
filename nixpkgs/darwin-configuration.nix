# See: https://daiderd.com/nix-darwin/manual/index.html

{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "63f299b3347aea183fc5088e4d6c4a193b334a41";
    ref = "release-20.09";
  };

  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  # Imports.
  imports = lib.lists.flatten [
    (import "${home-manager}/nix-darwin")
  ];

  # Nix Packages.
  nixpkgs.config.allowUnfree = true;

  # Environment.
  environment.systemPackages = with pkgs; lib.lists.flatten [
    # Basic packages.
    coreutils
    wget
    curl
    htop
    git
    jq
    tmux
    zip
    unzip
    xclip
    bind # dig
    lsof

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
    unstable.neovim
    unstable.neovide
    emacs
    unstable.vscode
    # (
    #   unstable.vscode-with-extensions.override {
    #     vscodeExtensions = import ../vscode/extensions.nix args;
    #   }
    # )

    # Browsers.
    # firefox

    # Terminals.
    unstable.alacritty

    # Compilers, interpreters and dev packages.
    # gnumake
    # clang
    # clang-tools
    # gcc
    # cmake
    # llvm
    # ccls
    go
    # gotools
    # unstable.gopls
    # godef
    # go-outline
    # gomodifytags
    # impl
    # unstable.delve
    nodejs
    python
    # (
    #   python3.withPackages (
    #     packages: with packages; [
    #       telethon
    #     ]
    #   )
    # )
    ruby
    # localPkgs.rustup-openssl
    # rust-analyzer
    # ghc
    # stack
    # haskellPackages.brittany
    # elmPackages.elm
    # dart
    # unstable.flutter
    shfmt
    nixpkgs-fmt
    # rnix-lsp
    # terraform-lsp
    # arduino
    # localPkgs.difftastic
    nodePackages.prettier

    # Docker.
    docker
    docker-compose

    # Misc.
    tldr # Simple man pages.
    lf # Terminal file manager.
    fzf # A command-line fuzzy finder written in Go.
    ripgrep # A utility that combines the usability of The Silver Searcher with the raw speed of grep.
    mu
    mutt # CLI email client.
    notmuch
    neomutt # CLI email client with some extras.
  ];

  environment.variables = {
    NIX_IGNORE_SYMLINK_STORE = "1";
  };

  # Programs.
  programs = {
    bash.enable = true;
    fish.enable = true;
    zsh.enable = true;
  };

  # Home Manager.
  home-manager.users.superpaintman = {
    home.file = {
      ".zshrc.local".text = ''
        # Env.
        export NIX_IGNORE_SYMLINK_STORE=1
        export NIX_PATH="darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH"

        # Run Nix.
        if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
          source "$HOME/.nix-profile/etc/profile.d/nix.sh"
        fi
      '';
    };
  };

  # System.
  # $ defaults read
  system.defaults = {
    # See: https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/dock.nix
    # $ killall Dock
    dock = {
      autohide = false;
      show-process-indicators = true;
      static-only = false;
      tilesize = 48;
    };
  };

  system.activationScripts.postUserActivation.text = ''
    for app in "ControlStrip" "Dock" "Finder"; do
      if killall "$app" > /dev/null 2>&1; then
        echo "app $app has reloaded" 1>&2
      fi
    done
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
