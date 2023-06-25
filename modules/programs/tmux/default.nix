# See: https://github.com/tmux/tmux/wiki
# See: https://linux.die.net/man/1/tmux
# See: http://man.openbsd.org/OpenBSD-current/man1/tmux.1
# See: https://github.com/tmux/tmux/blob/3.3/key-bindings.c#L344

# TODO(SuperPaintman):
# - [ ] Attach to the previous session when the current one is closed.

{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs.lib.x.generators) mkWTKKeyBinding toWTKConfig;

  cfg = config.modules.programs.tmux;
  theme = config.modules.themes.theme;
  standalone = config.modules.home.standalone;

  includeFile' =
    { TMUX_HOME
    , standalone ? false
    }: filename:
    let
      path = strings.normalizePath (TMUX_HOME + "/" + filename);
    in
    if standalone
    then ''
      if-shell '[ -f "${path}" ]' {
        source-file "${path}"
      }
    ''
    else ''
      source-file "${path}"
    '';
  includeFile = includeFile' {
    inherit standalone;
    TMUX_HOME = config.environment.variables.TMUX_HOME;
  };

  toHEX = v:
    if v == 0 then "0"
    else if v == 1 then "1"
    else if v == 2 then "2"
    else if v == 3 then "3"
    else if v == 4 then "4"
    else if v == 5 then "5"
    else if v == 6 then "6"
    else if v == 7 then "7"
    else if v == 8 then "8"
    else if v == 9 then "9"
    else if v == 10 then "A"
    else if v == 11 then "B"
    else if v == 12 then "C"
    else if v == 13 then "D"
    else if v == 14 then "E"
    else if v == 15 then "F"
    else
      assertMsg false "Invalid hex number.";

  toHEXColorChannel = c:
    let
      c1 = c / 16;
      c2 = c - (c1 * 16);
    in
    "${toHEX c1}${toHEX c2}";

  toHEXColor = color: "#${toHEXColorChannel color.r}${toHEXColorChannel color.g}${toHEXColorChannel color.b}";

  style = { fg ? "", bg ? "", bold ? false }:
    let
      foreground =
        if fg == "" then ""
        else if fg == "default" then fg
        else "#" + (toHEXColor theme.colors.${fg}.color);
      background =
        if bg == "" then ""
        else if bg == "default" then bg
        else "#" + (toHEXColor theme.colors.${bg}.color);
    in
    concatStringsSep "" ([ ]
      # Foreground.
      ++ optional (foreground != "" || bold) ("#[fg=" + (concatStringsSep "," ([ ]
      ++ optional (foreground != "") foreground
      ++ optional bold "bold")) + "]")
      # Background.
      ++ optional (background != "") "#[bg=${background}]");

  mkWindowStatusFormat = s:
    let
      color1 = {
        default = "base4";
        current = "darkBlue";
      }.${s};
      color2 = {
        default = "base5";
        current = "blue";
      }.${s};
    in
    concatStringsSep "" [
      "#{?#{window_start_flag},"
      (style { fg = color1; bg = "default"; })
      ","
      "#{?#{==:#{window_index},#{active_window_index}},"
      (style { fg = color1; bg = "base5"; })
      ","
      (style { fg = "base4"; bg = "base5"; })
      "}"
      "}"
      ""

      (style { bg = color1; fg = "brightWhite"; bold = true; })
      " #I "
      (style { bg = color2; fg = color1; bold = true; })
      ""

      "#{?#{window_zoomed_flag},"
      (style { bg = color2; fg = "brightWhite"; })
      " 󰍉"
      ","
      "}"

      (style { bg = color2; fg = "brightWhite"; })
      " #W "

      "#{?#{window_activity_flag},"
      (style { bg = color2; fg = "brightYellow"; })
      ""
      ","
      "}"

      "#{?#{window_end_flag},"
      (style { fg = color2; bg = "default"; })
      ","
      "#{?#{==:#{window_index},#{active_window_index}},"
      (style { fg = color2; bg = "base5"; })
      ","
      (style { fg = "base5"; bg = "base5"; })
      "}"
      "}"
      ""
    ];

  # TODO(SuperPaintman): generate from key bindings.
  wtkConfig = pkgs.writeText "wtk-tmux.json" (toWTKConfig {
    "Tmux" = (mkOrder 1) [
      (mkWTKKeyBinding [{ leader = true; keys = [ "?" ]; }] "List key bindings.")
      (mkWTKKeyBinding [{ leader = true; keys = [ "/" ]; }] "Enter in thumbs mode.")
      (mkWTKKeyBinding [{ leader = true; keys = [ "~" ]; }] "Show messages.")
      (mkWTKKeyBinding [{ leader = true; keys = [ "d" ]; }] "Detach the current client.")
    ];
    "Session" = (mkOrder 2) [
      (mkWTKKeyBinding [{ leader = true; keys = [ "$" ]; }] "Rename current session.")
    ];
    "Window" = (mkOrder 3) [
      (mkWTKKeyBinding [{ leader = true; keys = [ "Space" ]; }] "Select next layout.")
      (mkWTKKeyBinding [{ leader = true; keys = [ "," ]; }] "Rename current window.")
      (mkWTKKeyBinding [{ leader = true; keys = [ "c" ]; }] "Create a new window.")
      (mkWTKKeyBinding [{ leader = true; keys = [ "w" ]; }] "Choose a window from a list.")
    ];
    "Pane" = (mkOrder 4) [
      (mkWTKKeyBinding [{ leader = true; keys = [ "!" ]; }] "Break pane to a new window.")
      (mkWTKKeyBinding [{ leader = true; keys = [ ";" ]; }] "Move to the previously active pane.")
      (mkWTKKeyBinding [{ leader = true; keys = [ "x" ]; }] "Kill the active pane.")
      (mkWTKKeyBinding [{ leader = true; keys = [ "z" ]; }] "Zoom the active pane.")
    ];
    "Buffer" = (mkOrder 5) [
      (mkWTKKeyBinding [{ leader = true; keys = [ "#" ]; }] "List all paste buffers.")
      (mkWTKKeyBinding [{ leader = true; keys = [ "p" ]; }] "Paste the most recent paste buffer.")
      (mkWTKKeyBinding [{ leader = true; keys = [ "y" ]; }] "Enter copy mode.")
    ];
    "Find" = (mkOrder 6) [
      (mkWTKKeyBinding [{ leader = true; keys = [ "f" ]; }] "Enter in find mode.")
      (mkWTKKeyBinding [{ leader = true; keys = [ "f" ]; } { keys = [ "s" ]; }] "Find the session.")
    ];
  });

  tmux-thumbs = pkgs.callPackage ./plugins/tmux-thumbs {
    tmux = cfg.package;
  };

  tmux-session-manager = pkgs.extras.override {
    tmux = cfg.package;
  };

  # TODO(SuperPaintman): review the following plugins:
  #     - https://github.com/tmux-plugins/tmux-logging
  #     - https://github.com/trevarj/tmux-open-nvim

  clipboard =
    if pkgs.stdenv.hostPlatform.isLinux
    then "${pkgs.xclip}/bin/xclip -selection clipboard"
    else if pkgs.stdenv.hostPlatform.isMacOS
    then "pbcopy"
    else assertMsg false "Unsupported platform.";
in

{
  # Options.
  options.modules.programs.tmux = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc ''
        Whenever to configure `tmux`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.tmux;
      defaultText = literalExpression "pkgs.tmux";
      description = mdDoc ''
        The tmux package to use.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = [ cfg.package ];

      environment.variables = {
        TMUX_HOME = "$XDG_CONFIG_HOME/tmux";
      };

      home.configFiles = {
        "tmux/tmux.conf".text = ''
          ${includeFile "options.conf"}
          ${includeFile "key-bindings.conf"}
          ${includeFile "key-bindings-extra.conf"}
          ${includeFile "theme.conf"}
          ${includeFile "plugins.conf"}
        '';
        "tmux/options.conf".source = ./options.conf;
        "tmux/key-bindings.conf".source = ./key-bindings.conf;
        "tmux/key-bindings-extra.conf".text = ''
          # WTK.
          unbind-key ?
          bind-key ? split-window -Z ${escapeShellArg
            "cat ${wtkConfig} | ${pkgs.wtk}/bin/wtk --color=always | ${pkgs.less}/bin/less"
          }

          # Tmux Session Manager.
          unbind-key -T custom-table-find s
          ${optionalString (!standalone) ''
            bind-key -T custom-table-find s new-window -n 'tmux-session-manager' ${escapeShellArg
              "${tmux-session-manager}/bin/tmux-session-manager"
            }
          ''}
        '';
        "tmux/theme.conf".text = ''
          # Set the position of the status line
          # set-option -g status-position top

          # Set the position of the window list component of the status line:
          # left, centre or right justified.
          set-option -g status-justify left

          # Set the maximum length of the left component of the status line.
          set-option -g status-left-length 100

          # Set the maximum length of the right component of the status line.
          set-option -g status-right-length 100

          # Set status line style.
          set-option -g status-style ${escapeShellArg "bg=${toHEXColor theme.colors.base2.color}"}

          # Set the pane border style for panes aside from the active pane.
          set-option -g pane-border-style ${escapeShellArg "fg=${toHEXColor theme.colors.base5.color}"}

          # Set the pane border style for the currently active pane.
          set-option -g pane-active-border-style ${escapeShellArg "fg=${toHEXColor theme.colors.blue.color}"}

          # Display string to the left of the status line.
          set-option -g status-left ${escapeShellArg (concatStringsSep "" [
            # Marker.
            "#{?client_prefix,"
            (style { fg = "green"; })
            ","
            "#{?#{==:#{pane_mode},copy-mode},"
            (style { fg = "blue"; })
            ","
            (style { fg = "brightWhite"; })
            "}"
            "}"
            "    "

            # End.
            "#[default]"
          ])}

          # Sets the separator drawn between windows in the status line.
          set-option -g window-status-separator ""

          # Like window-status-format, but is the format used when the window
          # is the current window.
          set-option -g window-status-current-format ${escapeShellArg (mkWindowStatusFormat "current")}

          # Set the format in which the window is displayed in the status line
          # window list.
          set-option -g window-status-format ${escapeShellArg (mkWindowStatusFormat "default")}

          # Display string to the right of the status line.
          set-option -g status-right ${escapeShellArg (concatStringsSep "" [
            # Window.
            # (style { fg = "magenta"; })
            # ""
            # (style { bg = "magenta"; fg = "brightWhite"; })
            # "  "
            # (style { bg = "magenta"; fg = "brightWhite"; bold = true; })
            # " #W "
            # (style { bg = "magenta"; })

            # Session.
            (style { fg = "magenta"; })
            ""
            (style { bg = "magenta"; fg = "brightWhite"; })
            "  "
            (style { bg = "magenta"; fg = "brightWhite"; bold = true; })
            " #S "
            (style { bg = "magenta"; })

            # End.
            " "
            "#[default]"
          ])}

          # Set status line style for windows with an activity alert.
          set-option -g window-status-activity-style 'default'

          # Set status line message command style. This is used for the command
          # prompt with vi(1) keys when in command mode.
          set-option -g message-command-style ${escapeShellArg "bg=${toHEXColor theme.colors.base2.color}"}

          # Set status line message style. This is used for messages and for
          # the command prompt.
          set-option -g message-style ${escapeShellArg "bg=${toHEXColor theme.colors.base2.color}"}
        '';
        "tmux/plugins.conf".text = ''
          # Tmux Thumbs.
          unbind-key /
          ${optionalString (!standalone) ''
            # Choose which key is used to enter in thumbs mode.
            set-option -g @thumbs-key '/'

            # Add extra patterns to match. This parameter can have multiple instances.
            # Nix SHA256 pattern.
            set-option -g @thumbs-regexp-1 'sha256-(?:[a-zA-Z0-9+=\\/]+)'

            # Choose which command execute when you press a hint. tmux-thumbs will
            # replace {} with the picked hint.
            set-option -g @thumbs-command 'tmux set-buffer -- {}'

            # Choose which command execute when you press a upcase hint.
            # tmux-thumbs will replace {} with the picked hint.
            set-option -g @thumbs-upcase-command 'echo -n {} | ${clipboard}'

            # Run the plugin.
            run-shell ${tmux-thumbs}/bin/tmux-thumbs.tmux
          ''}
        '';
      };
    };
  };
}
