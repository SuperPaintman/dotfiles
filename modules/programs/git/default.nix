# See: https://search.nixos.org/options?channel=25.11&query=programs.git

{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.programs.git;

  mkGitHook = name: text: let 
    before = ''
      GIT_DIR="''${GIT_DIR:-"$(git rev-parse --show-toplevel)"}"
      if [ "$?" != 0 ]; then
        exit "$?"
      fi

      # Run local git hook if it exists.
      if [ -e "$GIT_DIR/.git/hooks/"${escapeShellArg name} ]; then
        eval "$GIT_DIR/.git/hooks/"${escapeShellArg name} $@
        exit "$?"
      fi

      # Run git hook from '.githooks' if it exists.
      if [ -e "$GIT_DIR/.githooks/"${escapeShellArg name} ]; then
        eval "$GIT_DIR/.githooks/"${escapeShellArg name} $@
        exit "$?"
      fi
    '';
  in pkgs.writeTextFile {
    name = "git-hook-${name}";
    executable = true;
    text = ''
      #!${if standalone then "/usr/bin/env bash" else pkgs.runtimeShell}
      set -eou pipefail

      ${before}
      ${text}
    '';
    checkPhase = ''
      ${pkgs.stdenv.shellDryRun} "$target"
    '';
  };

  hooks = {
    applypatch-msg = '''';
    commit-msg = '''';
    fsmonitor-watchman = '''';
    p4-changelist = '''';
    p4-post-changelist = '''';
    p4-pre-submit = '''';
    p4-prepare-changelist = '''';
    post-applypatch = '''';
    post-checkout = '''';
    post-commit = '''';
    post-index-change = '''';
    post-merge = '''';
    post-receive = '''';
    post-rewrite = '''';
    post-update = '''';
    pre-applypatch = '''';
    pre-auto-gc = '''';
    pre-commit = '''';
    pre-merge-commit = '''';
    pre-push = '''';
    pre-rebase = '''';
    pre-receive = '''';
    prepare-commit-msg = ''
      is-only-comments() {
        while read line; do
          if [ "$(echo "$line" | sed 's/^#.*$//')" != "" ]; then
            return 1
          fi
        done

        return 0
      }

      remove-leading-empty-lines() {
        local found_non_empty=""

        while read line; do
          if [ "$found_non_empty" != "" ]; then
            echo "$line"
            continue
          fi

          if [ "$(echo "$line" | sed 's/^#\s*$//')" != "" ]; then
            echo "$line"

            found_non_empty=yes
          fi
        done
      }

      # Do not modify commit message if we have non-comment lines.
      if ! cat "$1" | is-only-comments; then
        exit 0
      fi

      ORIGINAL_COMMIT_MSG="$(
        cat "$1" |
          sed 's/# Please enter the commit message for your changes. Lines starting/#/' |
          sed 's/# with .#. will be ignored, and an empty message aborts the commit\./#/' |
          remove-leading-empty-lines
      )"

      {
        echo ""
        echo ""
        echo "#"
        echo "$ORIGINAL_COMMIT_MSG"
        cat << EOF
      # <type>(<scope>): <message>
      #
      # Types:
      #   - build      Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm).
      #   - ci         Changes to our CI configuration files and scripts (example scopes: Circle, BrowserStack, SauceLabs).
      #   - docs       Documentation only changes.
      #   - feat       A new feature.
      #   - fix        A bug fix.
      #   - perf       A code change that improves performance.
      #   - refactor   A code change that neither fixes a bug nor adds a feature.
      #   - test       Adding missing tests or correcting existing tests.
      #
      # See: https://github.com/angular/angular/blob/master/CONTRIBUTING.md
      #
      EOF

      } > "$1"
    '';
    proc-receive = '''';
    push-to-checkout = '''';
    reference-transaction = '''';
    sendemail-validate = '''';
    update = '''';
  };
in

{
  # Options.
  options.modules.programs.git = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc ''
        Whenever to configure `git`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.git;
      defaultText = literalExpression "pkgs.git";
      description = mdDoc ''
        The git package to use.
      '';
    };

    config = mkOption {
      type = attrsOf (attrsOf anything);
      default = {};
    };
  };

  # Config.
  config = mkMerge [
    {
      modules.programs.git.config = let
        mkDefaultAll = attrs: mapAttrs
          (name: value: if isAttrs value then mkDefaultAll value else mkDefault value)
          attrs;
      in mkDefaultAll {
        core = {
          editor = "$EDITOR";
          # hooksPath = "$XDG_CONFIG_HOME/git/hooks";
          hooksPath = "~/.config/git/hooks";
        };

        diff.tool = "difft";
        difftool.prompt = false;
        difftool.difft.cmd = ''${pkgs.difftastic}/bin/difft "$LOCAL" "$REMOTE"'';

        # TODO(SuperPaintman): move into a global config.
        user = {
          email = "SuperPaintmanDeveloper@gmail.com";
          name = "Aleksandr Krivoshchekov";
          signingkey = "276C05A283B13321";
        };
        github.user = "SuperPaintman";

        commit.gpgsign = true;

        color.ui = true;
        color.status = {
          added = "green";
          changed = "yellow";
          untracked = "magenta";
          deleted = "red";
        };

        alias = {
          # A
          ## Alias
          aliases = "config --get-regexp alias";

          # B
          ## Branch
          branches = "branch -a";

          # C
          ## Checkout
          co = "checkout";

          ## Commit
          c = "commit";

          ## Contributors
          contributors = "shortlog --summary --numbered --email";

          ## Current Branch
          current-branch = "rev-parse --abbrev-ref HEAD";
          cb = "!git current-branch";

          ## Current Commit.
          current-commit = "rev-parse HEAD";
          cm = "!git current-commit";

          # D
          ## Diff
          d = "diff";

          # F
          ## Fetch
          f = "fetch --all";

          # G
          ## Get.
          get = "!git-get";

          # L
          ## Logs
          l = let
            # See: https://git-scm.com/docs/pretty-formats
            hash = "%h";
            ref = "%d";
            subject = "%s";
            relative-commit-date = "%cr";
            author-name = "%an";
            c = color: "%C(${color})";
            cr = c "reset";

            format = concatStringsSep "" [
              "${c "yellow"}${hash}${cr}"
              " -"
              "${c "auto"}${ref}${cr}"
              " ${subject} "
              "${c "green"}(${relative-commit-date})${cr}"
              " "
              "${c "bold blue"}<${author-name}>${cr}"
            ];
          in concatStringsSep " " [
            "log"
            "--graph"
            "--all"
            "--abbrev-commit"
            "--date=relative"
            "--pretty=format:${escapeShellArg format}"
          ];

          # M
          ## Merge
          m = "merge --no-ff";

          # P
          ## Push
          p = "push";
          poc = ''!git push origin "$(git current-branch)"'';

          ## Pull
          puc = ''!git pull origin "$(git current-branch)"'';

          # S
          ## Status
          s = "status --short --branch --find-renames --untracked-files=all";

          ## Stash
          sin = "stash --include-untracked";
          sout = "stash pop";

          # T
          ## Tag
          tags = "tag -l";
        };

        url."git@github.com:".insteadOf = "https://github.com/";
      };
    }
    (mkIf cfg.enable {
      modules = {
        users.packages = [ cfg.package ];

        home.files = {
          ".gitconfig".text = generators.toGitINI {
            # include.path = "$XDG_CONFIG_HOME/git/gitconfig";
            include.path = "~/.config/git/gitconfig";
          };
        };
        home.configFiles = {
          "git/gitconfig".text = generators.toGitINI cfg.config;
        }
        // mapAttrs'
          (name: value: nameValuePair "git/hooks/${name}" { source = mkGitHook name value; })
          hooks;
      };
    })
  ];
}
