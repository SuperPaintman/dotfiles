# See: https://thevaluable.dev/zsh-completion-guide-examples/
{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.modules.home) standalone;

  cfg = config.modules.shell.zsh;

  common = pkgs.callPackage ../common.nix { inherit config; };

  mkZSHOptions = flip pipe [
    (filterAttrs (n: v: v != null))
    (mapAttrs (n: v: if v then "setopt" else "unsetopt"))
    (mapAttrsToList (n: cmd: ''${cmd} ${n}''))
    (concatStringsSep "\n")
  ];

  ZSH_VERSION = if standalone then "\${ZSH_VERSION}" else cfg.package.version;

  ZSH_CACHE_DIR = "\${XDG_CACHE_HOME:-\"$HOME\"/.cache}/zsh";
  ZSH_COMPDUMP = "${ZSH_CACHE_DIR}/zcompdump-${ZSH_VERSION}";
in

{
  # Options.
  options.modules.shell.zsh = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure `zsh`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.zsh;
      defaultText = literalExpression "pkgs.zsh";
      description = ''
        The zsh package to use.
      '';
    };

    variables = common.options.variables;
    extras.variables = common.lib.mkExtraOption "variables" { };

    options = mkOption {
      type = attrsOf (nullOr bool);
      default = { };
      description = ''
        The set of bash options.
      '';
      apply =
        flip pipe [
          (filterAttrs (n: v: v != null))
        ];
    };
    extras.options = common.lib.mkExtraOption "options" { };

    aliases = common.options.aliases;
    extras.aliases = common.lib.mkExtraOption "aliases" { };

    keyBindings = common.options.keyBindings;
    extras.keyBindings = common.lib.mkExtraOption "keyBindings" { };

    functions = mkOption {
      type = lines;
      default = "";
      description = ''
        Shell functions.
      '';
    };
    extras.functions = common.lib.mkExtraOption "functions" { };

    theme = mkOption {
      type = lines;
      default = "";
      description = ''
        Shell theme.
      '';
    };
    extras.theme = common.lib.mkExtraOption "theme" { };

    plugins = mkOption {
      type = lines;
      default = "";
      description = ''
        ZSH plugins.
      '';
    };
    extras.plugins = common.lib.mkExtraOption "plugins" { };


    # Entire config.
    extras.config = common.lib.mkExtraOption "config" { };
  };

  # Config.
  config = mkMerge [
    # Common options.
    {
      modules.shell.zsh = {
        variables = mapAttrs (n: mkDefault) config.modules.shell.variables;
        aliases = mapAttrs (n: mkDefault) config.modules.shell.aliases;
        functions = config.modules.shell.functions;
        theme = ''
          ${builtins.readFile ../theme.sh}
          ${builtins.readFile ../theme.zsh}
        '';
      };
    }

    (mkIf cfg.enable {
      modules = {
        users.packages = [ cfg.package ];

        # See: https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell.html
        shell.zsh.variables = {
          # The maximum number of history events to save in the history file.
          #
          # If this is made local, it is not implicitly set to 0, but may be
          # explicitly set locally.
          SAVEHIST = "10000";

          # The maximum number of events stored in the internal history list.
          # If you use the HIST_EXPIRE_DUPS_FIRST option, setting this value
          # larger than the SAVEHIST size will give you the difference as a
          # cushion for saving duplicated history events.
          #
          # If this is made local, it is not implicitly set to 0, but may be
          # explicitly set locally.
          HISTSIZE = "50000";

          # The file to save the history in when an interactive shell exits.
          # If unset, the history is not saved.
          HISTFILE = "$XDG_STATE_HOME/zsh/history";

          # A list of non-alphanumeric characters considered part of a word by
          # the line editor.
          WORDCHARS = "";

          # Non-standard.
          inherit ZSH_CACHE_DIR ZSH_COMPDUMP;
        };

        # See: https://zsh.sourceforge.io/Doc/Release/Options.html
        shell.zsh.options = {
          ## 16.2.1 Changing Directories #######################################

          # If a command is issued that can’t be executed as a normal command,
          # and the command is the name of a directory, perform the cd command
          # to that directory. This option is only applicable if the option
          # SHIN_STDIN is set, i.e. if commands are being read from standard
          # input. The option is designed for interactive use; it is
          # recommended that cd be used explicitly in scripts to avoid
          # ambiguity.
          AUTO_CD = true;

          # Make cd push the old directory onto the directory stack.
          AUTO_PUSHD = true;

          # Don’t push multiple copies of the same directory onto the directory
          # stack.
          PUSHD_IGNORE_DUPS = true;

          # Exchanges the meanings of ‘+’ and ‘-’ when used with a number to
          # specify a directory in the stack.
          PUSHD_MINUS = true;


          ## 16.2.2 Completion #################################################

          # If a completion is performed with the cursor within a word, and a
          # full completion is inserted, the cursor is moved to the end of the
          # word. That is, the cursor is moved to the end of the word if either
          # a single match is inserted or menu completion is performed.
          ALWAYS_TO_END = true;

          # Automatically use menu completion after the second consecutive
          # request for completion, for example by pressing the tab key
          # repeatedly. This option is overridden by MENU_COMPLETE.
          AUTO_MENU = true;

          # If unset, the cursor is set to the end of the word if completion
          # is started. Otherwise it stays there and completion is done from
          # both ends.
          COMPLETE_IN_WORD = true;

          # On an ambiguous completion, instead of listing possibilities or
          # beeping, insert the first match immediately. Then when completion
          # is requested again, remove the first match and insert the second
          # match, etc. When there are no more matches, go back to the first
          # one again. reverse-menu-complete may be used to loop through the
          # list in the other direction. This option overrides AUTO_MENU.
          MENU_COMPLETE = false;


          ## 16.2.4 History ####################################################

          # Save each command’s beginning timestamp (in seconds since the
          # epoch) and the duration (in seconds) to the history file.
          # The format of this prefixed data is:
          #
          # ‘: <beginning time>:<elapsed seconds>;<command>’.
          EXTENDED_HISTORY = true;

          # If the internal history needs to be trimmed to add the current
          # command line, setting this option will cause the oldest history
          # event that has a duplicate to be lost before losing a unique event
          # from the list. You should be sure to set the value of HISTSIZE to
          # a larger number than SAVEHIST in order to give you some room for
          # the duplicated events, otherwise this option will behave just like
          # HIST_IGNORE_ALL_DUPS once the history fills up with unique events.
          HIST_EXPIRE_DUPS_FIRST = true;

          # When writing out the history file, by default zsh uses ad-hoc file
          # locking to avoid known problems with locking on some operating
          # systems. With this option locking is done by means of the system’s
          # fcntl call, where this method is available. On recent operating
          # systems this may provide better performance, in particular avoiding
          # history corruption when files are stored on NFS. 
          HIST_FCNTL_LOCK = true;

          # Do not enter command lines into the history list if they are 
          # duplicates of the previous event.
          HIST_IGNORE_DUPS = true;

          # Remove command lines from the history list when the first
          # character on the line is a space, or when one of the expanded
          # aliases contains a leading space. Only normal aliases (not global
          # or suffix aliases) have this behaviour. Note that the command
          # lingers in the internal history until the next command is entered
          # before it vanishes, allowing you to briefly reuse or edit the line.
          # If you want to make it vanish right away without entering another
          # command, type a space and press return.
          HIST_IGNORE_SPACE = true;

          # This option both imports new commands from the history file,
          # and also causes your typed commands to be appended to the history 
          # file (the latter is like specifying INC_APPEND_HISTORY, which 
          # should be turned off if this option is in effect). 
          #
          # The history lines are also output with timestamps ala 
          # EXTENDED_HISTORY (which makes it easier to find the spot where we
          # left off reading the file after it gets re-written). 
          SHARE_HISTORY = true;

          # Whenever the user enters a line with history expansion, don’t
          # execute the line directly; instead, perform history expansion
          # and reload the line into the editing buffer.
          HIST_VERIFY = true;

          # This option works like APPEND_HISTORY except that new history lines
          # are added to the $HISTFILE incrementally (as soon as they are
          # entered), rather than waiting until the shell exits. The file will
          # still be periodically re-written to trim it when the number of
          # lines grows 20% beyond the value specified by $SAVEHIST (see also
          # the HIST_SAVE_BY_COPY option).
          INC_APPEND_HISTORY = true;


          ## 16.2.6 Input/Output ###############################################

          # Allow comments even in interactive shells.
          INTERACTIVE_COMMENTS = true;

          # If this option is unset, output flow control via start/stop
          # characters (usually assigned to ^S/^Q) is disabled in the shell’s
          # editor.
          FLOW_CONTROL = false;


          ## 16.2.7 Job Control ################################################

          # Print job notifications in the long format by default.
          LONG_LIST_JOBS = true;

          ## 16.2.8 Prompting ##################################################

          # Attempt to preserve a partial line (i.e. a line that did not end
          # with a newline) that would otherwise be covered up by the command
          # prompt due to the PROMPT_CR option. This works by outputting some
          # cursor-control characters, including a series of spaces, that should
          # make the terminal wrap to the next line when a partial line is
          # present (note that this is only successful if your terminal has
          # automatic margins, which is typical).
          PROMPT_SP = true;

          # If set, parameter expansion, command substitution and arithmetic
          # expansion are performed in prompts. Substitutions within prompts
          # do not affect the command status.
          PROMPT_SUBST = true;


          ## 16.2.9 Scripts and Functions ######################################

          # Perform implicit tees or cats when multiple redirections are 
          # attempted (see Redirection).
          MULTIOS = true;
        };

        shell.zsh.extras.options.after = let 
          ignoredHardcodedUsers = [
            # Oh-My-ZSH
            "adm"
            "amanda"
            "apache"
            "at"
            "avahi"
            "avahi-autoipd"
            "beaglidx"
            "bin"
            "cacti"
            "canna"
            "clamav"
            "daemon"
            "dbus"
            "distcache"
            "dnsmasq"
            "dovecot"
            "fax"
            "ftp"
            "games"
            "gdm"
            "gkrellmd"
            "gopher"
            "hacluster"
            "haldaemon"
            "halt"
            "hsqldb"
            "ident"
            "junkbust"
            "kdm"
            "ldap"
            "lp"
            "mail"
            "mailman"
            "mailnull"
            "man"
            "messagebus"
            "mldonkey"
            "mysql"
            "nagios"
            "named"
            "netdump"
            "news"
            "nfsnobody"
            "nobody"
            "nscd"
            "ntp"
            "nut"
            "nx"
            "obsrun"
            "openvpn"
            "operator"
            "pcap"
            "polkitd"
            "postfix"
            "postgres"
            "privoxy"
            "pulse"
            "pvm"
            "quagga"
            "radvd"
            "rpc"
            "rpcuser"
            "rpm"
            "rtkit"
            "scard"
            "shutdown"
            "squid"
            "sshd"
            "statd"
            "svn"
            "sync"
            "tftp"
            "usbmux"
            "uucp"
            "vcsa"
            "wwwrun"
            "xfs"
            "_*"

            # Custom.
            "nixbld*"
            "systemd-*"
          ];

          isSystemUser = u:
            u.isSystemUser
            || !u.isNormalUser;
            # || u.uid < 1000;

          ignoredSystemUsers =
            if config ? users && config.users ? users
            then
              (pipe config.users.users [
                (filterAttrs (n: u:
                  (n != "root")
                  && !(hasPrefix "nixbld" n)
                  && !(hasPrefix "systemd-" n)
                  && (isSystemUser u)
                ))
                attrNames
              ]) ++ [
                "nixbld*"
                "systemd-*"
                "_*"
              ]
            else 
              [];

          ignoredUsers = if standalone then ignoredHardcodedUsers else ignoredSystemUsers;

          ignoredVariables = [
            "_*"

            "fg"
            "fg_bold"
            "fg_no_bold"
            "bg"
            "bg_bold"
            "bg_no_bold"
            "bold_color"
            "color"
            "colour"
            "reset_color"

            "PS1"
            "PS2"
            "PS3"
            "PS4"

            "PROMPT"
            "PROMPT2"
            "PROMPT3"
            "PROMPT4"
            "RPROMPT"

            "prompt_*"

            "ZSH_AUTOSUGGEST_*"
            "zsh_highlight_*"
            "ZSH_HIGHLIGHT_*"
            "ZSH_THEME_*"

            # Ignore any variable that doesnt start with [A-Z].
            "^[A-Z][A-Za-z0-9_]#"
          ];

          ignoredFunctions = [
            "_*"
          ];

          mkIgnoredPatterns = flip pipe [
            unique
            naturalSort
            (concatMapStringsSep " \\\n    " escapeShellArg)
          ];

          # See: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
          mkZStyle = context: style: value: let
            context' = if isString context then context else concatStringsSep ":" context;
            value' = if isString value then value else concatMapStringsSep " " escapeShellArg value;
          in
            "zstyle ${escapeShellArg context'} ${escapeShellArg style} ${value'}";

          mkZStyles = flip pipe [
            (map ({ context, style, value }: mkZStyle context style value))
            (concatStringsSep "\n")
          ];

          styles = rec {
            reset = "0";
            black = "30";
            red = "31";
            green = "32";
            yellow = "33";
            blue = "34";
            magenta = "35";
            cyan = "36";
            white = "37";

            boldBlack = "1;30";
            boldRed = "1;31";
            boldGreen = "1;32";
            boldYellow = "1;33";
            boldBlue = "1;34";
            boldMagenta = "1;35";
            boldCyan = "1;36";
            boldWhite = "1;37";

            brightBlack = "90";

            command = reset;
            separator = brightBlack;
            description = brightBlack;
            pid = boldMagenta;
            user = boldGreen;
          };

          sep = "·";
        in ''
          ## Colors ############################################################
          autoload -U colors && colors

          ## Completions #######################################################
          autoload -U compaudit
          autoload -U compinit

          # -C - dump file is only created if none exists.
          compinit -C -d "$ZSH_COMPDUMP"

          zmodload -i zsh/complist

          ${mkZStyles (flatten [
            # :completion:function:completer:command:argument:tag
            {
              context = [ "" "completion" "*" "*" "*" "*" "*" ];
              style = "menu";
              value = [ "select" ];
            }

            {
              context = [ "" "completion" "*" ];
              style = "list-separator";
              value = [ sep ];
            }

            # Case insensitive (all), partial-word and substring completion.
            {
              context = [ "" "completion" "*" ];
              style = "matcher-list";
              value = [ "m:{a-zA-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*" ];
            }

            # Complete . and .. special directories.
            {
              context = [ "" "completion" "*" ];
              style = "special-dirs";
              value = [ "true" ];
            }

            # Processes.
            {
              context = [ "" "completion" "*" "*" "*" "*" "processes" ];
              style = "command";
              value = "\"ps -u $USER -o pid,user,comm -w -w\"";
            }

            # Disable named-directories autocompletion.
            {
              context = [ "" "completion" "*" "cd" "*" ];
              style = "tag-order";
              value = [ "local-directories" "directory-stack" "path-directories" ];
            }

            # Make.
            # Outputs all possible results for make targets.
            {
              context = [ "" "completion" "*" "make" "*" "targets" ];
              style = "call-command";
              value = [ "on" ];
            }
            # Show only targets.
            {
              context = [ "" "completion" "*" "make" "*" ];
              style = "tag-order";
              value = [ "targets" ];
            }

            # Use caching so that commands like apt and dpkg complete are useable.
            {
              context = [ "" "completion" "" "complete" "*" ];
              style = "use-cache";
              value = [ "1" ];
            }
            {
              context = [ "" "completion" "" "complete" "*" ];
              style = "cache-path";
              value = "\"$ZSH_CACHE_DIR\"";
            }

            # Ignore system users.
            {
              context = [ "" "completion" "*" "*" "*" "users" ];
              style = "ignored-patterns";
              value = mkIgnoredPatterns ignoredUsers;
            }

            # Ignore some variables.
            {
              context = [ "" "completion" "*" "*" "*" "*" "parameters" ];
              style = "ignored-patterns";
              value = mkIgnoredPatterns ignoredVariables;
            }

            # Ignore some functions.
            {
              context = [ "" "completion" "*" "functions" ];
              style = "ignored-patterns";
              value = mkIgnoredPatterns ignoredFunctions;
            }

            {
              context = [ "*" ];
              style = "single-ignored";
              value = [ "show" ];
            }

            {
              context = [ "" "completion" "*" ];
              style = "format";
              value = [ "%F{242}[%d]%f" ];
            }

            (map
              (tag: [
                {
                  context = [ "" "completion" "*" "*" "*" "*" tag ];
                  style = "list-colors";
                  value = [ "" ];
                }
                {
                  context = [ "" "completion" "*" "*" "*" "*" tag ];
                  style = "list-colors";
                  value = "\"\${(s.:.)LS_COLORS}\"";
                }
              ])
              [ "files" "all-files" "directories" "local-directories" "globbed-files" "other-files" ])

            (map
              (tag: [
                {
                  context = [ "" "completion" "*" "*" "kill" "*" tag ];
                  style = "list-colors";
                  value = [ "" ];
                }
                {
                  context = [ "" "completion" "*" "*" "kill" "*" tag ];
                  style = "list-colors";
                  value = [
                    "=(#b)[ ]#([0-9]##)[ ]##([^ ]##)[ ]##(*)=${styles.reset}=${styles.pid}=${styles.user}=${styles.command}"
                  ];
                }
              ])
              [ "processes" ])

            (map
              (tag: [
                {
                  context = [ "" "completion" "*" "*" "*" "*" tag ];
                  style = "list-colors";
                  value = [ "" ];
                }
                {
                  context = [ "" "completion" "*" "*" "*" "*" tag ];
                  style = "list-colors";
                  value = [
                    "=(#b)([^${sep}]##)( ##${sep} ##)(*)=${styles.reset}=${styles.command}=${styles.separator}=${styles.description}"
                    "=(#b)( #${sep})(*)=${styles.reset}=${styles.separator}=${styles.description}"
                    # "=(#b)(*)=${styles.reset}=${styles.command}" # NOTE(SuperPaintman): changes the color of ANY completion.
                  ];
                }
              ])
              [ "*" ])
          ])}

          autoload -U +X bashcompinit && bashcompinit
        '';

        shell.zsh.keyBindings = let 
          ifInteractive = text: ''
            if [[ -o interactive ]]; then
            ${text}
            fi
          '';
        in mkMerge [
          (ifInteractive ''
            bindkey ' ' magic-space # Space - do history expansion.

            bindkey '^r' history-incremental-search-backward # Ctrl-r - Search backward incrementally for a specified string.

            # Start typing + Up-Arrow - fuzzy find history forward.
            if [[ "''${terminfo[kcuu1]}" != "" ]]; then
              autoload -U up-line-or-beginning-search
              zle -N up-line-or-beginning-search
              bindkey "''${terminfo[kcuu1]}" up-line-or-beginning-search
            fi

            # start typing + Down-Arrow - fuzzy find history backward.
            if [[ "''${terminfo[kcud1]}" != "" ]]; then
              autoload -U down-line-or-beginning-search
              zle -N down-line-or-beginning-search
              bindkey "''${terminfo[kcud1]}" down-line-or-beginning-search
            fi

            bindkey '^[[1;5C' forward-word # Ctrl-RightArrow - move forward one word.
            bindkey '^[[1;5D' backward-word # Ctrl-LeftArrow - move backward one word.
            
            if [[ "''${terminfo[kcbt]}" != "" ]]; then
              bindkey "''${terminfo[kcbt]}" reverse-menu-complete # Shift-Tab - move through the completion menu backwards.
            fi

            bindkey '^?' backward-delete-char # Backspace - delete backward.
            if [[ "''${terminfo[kdch1]}" != "" ]]; then
              bindkey "''${terminfo[kdch1]}" delete-char # Delete - delete forward.
            fi

            bindkey '^[^?' backward-kill-word # Alt-Backspace - delete word backward.

            # Edit the current command line in $EDITOR.
            autoload -U edit-command-line
            zle -N edit-command-line
            bindkey '^e' edit-command-line
          '')

          (ifInteractive ''
            # Vim-like jumplist: Ctrl-I and Ctrl-O
            autoload -Uz add-zsh-hook

            typeset -ga __JUMPLIST_BACK
            typeset -ga __JUMPLIST_FORWARD
            typeset -gi __JUMPLIST_MAX=100
            typeset -gi __JUMPLIST_LOCK=0

            __jumplist_cd() {
              local code=0
              if (( __JUMPLIST_LOCK != 0 )); then
                return "$code"
              fi

              __JUMPLIST_LOCK=1
              builtin cd -- "$1" || code="$?"
              __JUMPLIST_LOCK=0

              return "$code"
            }

            __jumplist_record_hook() {
              if (( __JUMPLIST_LOCK != 0 )); then
                return 0
              fi

              [[ -n "$OLDPWD" && "$OLDPWD" != "$PWD" ]] || return
              if (( "''${#__JUMPLIST_BACK}" >= __JUMPLIST_MAX )); then
                shift __JUMPLIST_BACK
              fi
              __JUMPLIST_BACK+=( "$OLDPWD" )
              __JUMPLIST_FORWARD=()

              return 0
            }
            add-zsh-hook chpwd __jumplist_record_hook

            jumplist-back() {
              local dst

              while (( "''${#__JUMPLIST_BACK}" )); do
                dst="''${__JUMPLIST_BACK[-1]}"

                __JUMPLIST_BACK[-1]=()
                [[ -d "$dst" && "$dst" != "$PWD" ]] || continue
                if (( "''${#__JUMPLIST_FORWARD}" >= __JUMPLIST_MAX )); then
                  shift __JUMPLIST_FORWARD
                fi
                __JUMPLIST_FORWARD+=( "$PWD" )
                __jumplist_cd "$dst"

                break
              done

              zle reset-prompt
            }
            zle -N jumplist-back

            jumplist-forward() {
              local dst

              while (( "''${#__JUMPLIST_FORWARD}" )); do
                dst="''${__JUMPLIST_FORWARD[-1]}"

                __JUMPLIST_FORWARD[-1]=()
                [[ -d "$dst" && "$dst" != "$PWD" ]] || continue
                __JUMPLIST_BACK+=( "$PWD" )
                __jumplist_cd "$dst"

                break
              done

              zle reset-prompt
            }
            zle -N jumplist-forward

            # 5 - Ctrl
            # 6 - Shift+Ctrl
            bindkey '^O' jumplist-back # Ctrl-o
            bindkey '^[[105;5u' jumplist-forward # Ctrl-i
          '')
        ];

        shell.zsh.aliases = {
          history = "builtin history -t '%Y-%m-%dT%H-%M-%S%z'";
        };

        shell.zsh.functions = ''
          reload() {
            source ~/.zshrc
          }
        '';

        shell.zsh.plugins = optionalString (!standalone) ''
          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        '';

        home.configFiles = {
          "zsh/zshrc.zsh".source = pkgs.writeTextFile {
            name = "zshrc.zsh";
            executable = true;
            text = ''
              # shellcheck disable=SC2148 # No shebang.
              # shellcheck disable=SC2120

              ################################################################################
              # Extras Before
              ################################################################################
              ${cfg.extras.config.before}

              ################################################################################
              # Variables.
              ################################################################################
              ${cfg.extras.variables.before}
              ${common.lib.mkExporedShEnvVars cfg.variables}
              ${cfg.extras.variables.after}

              ################################################################################
              # Options.
              ################################################################################
              ${cfg.extras.options.before}
              ${mkZSHOptions cfg.options}
              ${cfg.extras.options.after}

              ################################################################################
              # Aliases.
              ################################################################################
              ${cfg.extras.aliases.before}
              ${common.lib.mkShAliases cfg.aliases}
              ${cfg.extras.aliases.after}

              ################################################################################
              # Key Bindings.
              ################################################################################
              ${cfg.extras.keyBindings.before}
              ${cfg.keyBindings}
              ${cfg.extras.keyBindings.after}

              ################################################################################
              # Functions.
              ################################################################################
              ${cfg.extras.functions.before}
              ${cfg.functions}
              ${cfg.extras.functions.after}

              ################################################################################
              # Theme.
              ################################################################################
              ${cfg.extras.theme.before}
              ${cfg.theme}
              ${cfg.extras.theme.after}

              ################################################################################
              # Plugins.
              ################################################################################
              ${cfg.extras.plugins.before}
              ${cfg.plugins}
              ${cfg.extras.plugins.after}

              ################################################################################
              # Extras After
              ################################################################################
              ${cfg.extras.config.after}
            '';
            checkPhase = ''
              # Verify syntax checking by parsing a script without running
              # any commands.
              ${cfg.package}/bin/zsh -n -o extendedglob "$target"

              # ${pkgs.shellcheck}/bin/shellcheck "$target"
            '';
          };
        };

        home.files = {
          # TODO(SuperPaintman): delete later.
          # Backword compatability until files are migrated.
          ".zshrc.migration".text = ''
            export __DOTFILES_MIGRATION_ZSH=1
            if [ -f ~/.config/zsh/zshrc.zsh ]; then
              source ~/.config/zsh/zshrc.zsh
            fi
          '';
        };

        home.activation.zshXDGDirs = ''
          if [ ! -d "$XDG_CACHE_HOME/zsh" ]; then
            mkdir "$XDG_CACHE_HOME/zsh"
          fi

          if [ ! -d "$XDG_DATA_HOME/zsh" ]; then
            mkdir "$XDG_DATA_HOME/zsh"
          fi

          if [ ! -d "$XDG_STATE_HOME/zsh" ]; then
            mkdir "$XDG_STATE_HOME/zsh"
          fi
        '';

        home.activation.zshDeleteCompdump = ''
          if [ -f "${ZSH_COMPDUMP}" ]; then
            rm "${ZSH_COMPDUMP}"

            # NOTE(SuperPaintman): do not recreate the compdump here.
          fi
        '';
      };
    })
  ];
}
