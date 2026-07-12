{ pkgs ? import <nixpkgs> { }
, stdenvNoCC ? pkgs.stdenvNoCC
, lib ? pkgs.lib
, writeTextFile ? pkgs.writeTextFile
}:

let
  eval = lib.evalModules {
    modules = [
      ({ options, ... }: {
        options = {
          environment.variables = lib.mkOption {
            type = lib.types.anything;
            default = { };
          };

          environment.sessionVariables = lib.mkOption {
            type = lib.types.anything;
            default = { };
          };
        };

        config = {
          environment.variables = lib.mkAliasDefinitions options.environment.sessionVariables;
        };
      })

      # Custom modules.
      ./modules

      { _module.check = false; }
      { 
        modules = {
          home.standalone = true;

          xsession.xresources.enable = true;
          xsession.xmodmap.enable = true;

          programs = {
            alacritty.enable = true;
            # ansible.enable = true;
            bat.enable = true;
            discord.enable = true;
            essential.enable = true;
            essential.desktop.enable = true;
            # firefox.enable = true;
            fzf.enable = true;
            git.enable = true;
            lf.enable = true;
            neofetch.enable = true;
            # neovim.enable = true;
            rofi.enable = true;
            tmux.enable = true;
          };

          development = {
            cc.enable = true;
            dart.enable = true;
            dart.flutter.enable = true;
            essential.enable = true;
            go.enable = true;
            javascript.enable = true;
            lua.enable = true;
            protobuf.enable = true;
            python.enable = true;
            ruby.enable = true;
            rust.enable = true;
            zig.enable = true;
          };

          shell = {
            bash.enable = true;
            zsh.enable = true;
          };
        };
      }
    ];
    specialArgs = { inherit pkgs; };
  };

  inherit (eval.config.modules) home;

  mkFile = out: name: file: let
    f = if file ? source 
      then file.source
      else writeTextFile {
        inherit name;
        inherit (file) text;
      };
  in ''
    mkdir -p "$(dirname "${out}"/${lib.escapeShellArg name})"
    cp ${f} "${out}"/${lib.escapeShellArg name}
  '';

  mkFiles = out: lib.flip lib.pipe [
    (lib.mapAttrsToList (mkFile out))
    (lib.concatStringsSep "\n")
  ];
in

stdenvNoCC.mkDerivation rec {
  name = "dotfiles-standalone";

  dontUnpack = true;
  dontConfigure = true;
  dontPatch = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p "$out"

    ${mkFiles "$out" home.files}
    ${mkFiles "$out/.config" home.configFiles}
    ${mkFiles "$out/.local/share" home.dataFiles}
    ${mkFiles "$out/.local/user" home.fakeFiles}
  '';
}
