# Packages and common settings I prefer to always have.
#
# eza:
#    - https://github.com/eza-community/eza
{ pkgs, config, lib, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.programs.essential;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";
in

{
  # Options.
  options.modules.programs.essential = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure essential programs.
      '';
    };

    desktop.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure essential desktop programs.
      '';
    };
  };

  # Config.
  config = mkMerge [
    (mkIf cfg.enable rec {
      modules = {
        users.packages = with pkgs; [ 
          coreutils # df, dircolors
          tree
          which
          gnugrep # grep, fgrep, egrep
          bind # dig
          lsof

          wget
          curl
          htop

          vim
          jq

          eza
          jq
          fd
          ripgrep
        ];

        shell.variables = {
          EDITOR = mkOverride 900 (mkBin pkgs.vim "vim");
        };

        shell.aliases = {
          dfh = "${mkBin pkgs.coreutils "df"} -h --total";

          tree = "${mkBin pkgs.tree "tree"} -C";
          # tree = "${mkBin pkgs.eza "eza"} --color=auto --tree";

          where = mkBin pkgs.which "which";

          grep = "${mkBin pkgs.gnugrep "grep"} --color=auto"; # --exclude-dir={.bzr,CVS,.git,.hg,.svn}
          fgrep = "${mkBin pkgs.gnugrep "fgrep"} --color=auto";
          egrep = "${mkBin pkgs.gnugrep "egrep"} --color=auto";

          nvim = mkOverride 900 (mkBin pkgs.vim "vim");
          vim = mkOverride 900 null;
          vi = mkOverride 900 (mkBin pkgs.vim "vim");
          v = mkOverride 900 (mkBin pkgs.vim "vim");

          wget = ''${mkBin pkgs.wget "wget"} --hsts-file="$XDG_DATA_HOME/wget-hsts"'';

          ls = "${mkBin pkgs.eza "eza"} --color=auto";
        };

        shell.bash.extras.variables.after = let
          out = pkgs.runCommand "dircolors" { } ''
            eval "$(${pkgs.coreutils}/bin/dircolors -b)"
            echo -n "$LS_COLORS" > "$out"
          '';
        in ''
          # dircolors -b
          export LS_COLORS=${escapeShellArg (builtins.readFile out)}
        '';
        shell.zsh.extras.variables.after = modules.shell.bash.extras.variables.after;
      };
    })

    (mkIf cfg.desktop.enable {
      modules = {
        users.packages = with pkgs; [ 
          xclip
          xdg-utils
        ];

        shell.aliases = {
          pbcopy = "${mkBin pkgs.gnugrep "xclip"} -selection clipboard";
          pbpaste = "${mkBin pkgs.gnugrep "xclip"} -selection clipboard -o";

          open = mkBin pkgs.xdg-utils "xdg-open";
        };
      };
    })
  ];
}
