# See: https://github.com/tmux/tmux/wiki
# See: https://linux.die.net/man/1/tmux
# See: http://man.openbsd.org/OpenBSD-current/man1/tmux.1

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.programs.tmux;
  theme = config.modules.themes.theme;

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
    TMUX_HOME = config.environment.variables.TMUX_HOME;
    standalone = config.modules.home.standalone;
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

      home.files."colors-test".text = ''
        ${concatStringsSep "\n" (mapAttrsToList
          (name: color: ''
            printf ${escapeShellArg "\\x1b[38;2;${toString color.color.r};${toString color.color.g};${toString color.color.b}m[X]\\x1b[0m "}
            echo ${escapeShellArg name} " | " ${escapeShellArg "rgba(${toString color.color.r}, ${toString color.color.g}, ${toString color.color.b}, ${toString color.color.a})"} " | " ${toString color.ansi.foreground} ${toString color.ansi.background}
          '')
          config.modules.themes.theme.colors)}
      '';

      home.configFiles = {
        "tmux/tmux.conf".text = ''
          ${includeFile "options.conf"}
          ${includeFile "key-bindings.conf"}
          ${includeFile "theme.conf"}
        '';
        "tmux/options.conf".source = ./options.conf;
        "tmux/key-bindings.conf".source = ./key-bindings.conf;
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
            (style { fg = "brightWhite"; })
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
      };
    };
  };
}
