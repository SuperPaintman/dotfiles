# See: https://github.com/NixOS/nixos-hardware/tree/master/dell/xps/15-7590
# See: https://wiki.archlinux.org/index.php/Dell_XPS_15
# See: https://xps-15.fandom.com/wiki/XPS_15_Wiki

{ config, pkgs, lib, ... }:

{
  # Boot.
  boot.loader = {
    # Use the systemd-boot EFI boot loader.
    systemd-boot.enable = true;

    efi.canTouchEfiVariables = true;

    # SSD.
    # See: https://github.com/NixOS/nixos-hardware/blob/master/common/pc/ssd/default.nix
    # kernel.sysctl = {
    #   "vm.swappiness" = lib.mkDefault 1;
    # };
  };
  # Intel CPU.
  # See: https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/intel/default.nix
  boot.initrd.kernelModules = [ "i915" ];

  # Networking.
  networking = {
    useDHCP = false;

    interfaces.wlp59s0.useDHCP = true;
  };

  # Sound.
  sound.enable = true;

  # Hardware.
  hardware = {
    pulseaudio = {
      enable = true;
    };

    opengl = {
      enable = true;

      # Intel CPI.
      # See: https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/intel/default.nix
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };

    bluetooth = {
      enable = true;
    };

    # Intel CPU.
    # See: https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/intel/default.nix
    # cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    nvidia.prime = {
      # TODO(SuperPaintman): works not so well, display shows artifacts.
      # sync.enable = true;
      offload.enable = true;

      # Bus ID of the Intel GPU.
      intelBusId = "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU.
      nvidiaBusId = "PCI:1:0:0";
    };

    nvidia.powerManagement.enable = true;
  };

  # Nix Packages.
  # Allow unfree for Nvidia drivers.
  nixpkgs.config.allowUnfree = true;

  # Services.
  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      dpi = 96;
      screenSection = lib.optionalString (config.hardware.nvidia.prime.sync.enable) ''
        Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
        Option         "AllowIndirectGLXProtocol" "off"
        Option         "TripleBuffer" "on"
      '';

      # Display manager.
      displayManager =
        let
          xrandrCommands = with pkgs; ''
            if ${xorg.xrandr}/bin/xrandr --query 2>&1 | grep 'eDP-1-1 connected' 2>&1 > /dev/null; then
              DISPLAY_PRIMARY='eDP-1-1'
              DISPLAY_SECONDARY='DP-1-1'
            else
              DISPLAY_PRIMARY='eDP-1'
              DISPLAY_SECONDARY='DP-1'
            fi

            # Primary bottom.
            # ${xorg.xrandr}/bin/xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x1080 --output DP-3 --mode 1920x1080 --pos 0x0

            # Primary left.
            ${xorg.xrandr}/bin/xrandr --output "$DISPLAY_PRIMARY" --primary --mode 1920x1080 --pos 0x0 --output "$DISPLAY_SECONDARY" --mode 1920x1080 --pos 1920x0
          '';

          xinputToggleTouchpadCommand = with pkgs; writeShellScript "xinput-toggle-touchpad" ''
            set -e
            set -u
            set -o pipefail

            name="$1"

            device_id="$(${xorg.xinput}/bin/xinput list | ${gnugrep}/bin/grep "$name" | ${gnugrep}/bin/grep -Po 'id=(\d+)' | ${gawk}/bin/awk -F '=' '{print $2}')"
            if [[ "$device_id" == "" ]]; then
              exit 1
            fi

            state="$(${xorg.xinput}/bin/xinput list-props "$device_id" | ${gnugrep}/bin/grep 'Device Enabled' | ${gawk}/bin/awk '{print $4}')"

            if [[ "$state" == 1 ]]; then
              ${xorg.xinput}/bin/xinput disable "$device_id"
            else
              ${xorg.xinput}/bin/xinput enable "$device_id"
            fi
          '';

          xbindkeysConfig = {
            # See: `xbindkeys -d`
            # See: `xbindkeys -k`
            # See: `xmodmap -pk`
            bindings = with pkgs; [
              # pactl needs a logged in user to work.
              #
              # See: `pa_context_connect() failed: Connection refused`.
              # Fn+F1.
              {
                key = "XF86AudioMute";
                command = "${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
                session = true;
              }

              # Fn+F2.
              {
                key = "XF86AudioRaiseVolume";
                command = "${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
                session = true;
              }

              # Fn+F3.
              {
                key = "XF86AudioLowerVolume";
                command = "${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
                session = true;
              }

              # Fn+F9.
              {
                key = "XF86Search";
                command = "${xinputToggleTouchpadCommand} 'SYNA2393:00 06CB:7A13 Touchpad'";
              }

              # Fn+F11.
              {
                key = "XF86MonBrightnessDown";
                command = "${brightnessctl}/bin/brightnessctl set 5%-";
              }

              # Fn+F12.
              {
                key = "XF86MonBrightnessUp";
                command = "${brightnessctl}/bin/brightnessctl set +5%";
              }

              # Super+Alt+Space
              # Change keyboard language like OSX does.
              {
                key = "Mod4 + Alt + space";
                command = "${xkb-switch}/bin/xkb-switch --next";
              }
            ];
          };

          xbindkeysFilter = { session ? false }: bindings:
            builtins.filter (opts: (if opts ? "session" then opts.session else false) == session) bindings;

          toXbindkeysConfig = bindings: ''
            ${lib.concatMapStringsSep "\n"
              ({ key, command, ... }: ''
                "${command}"
                  ${key}
              '')
            bindings}
          '';

          xbindkeysRCSetup = pkgs.writeText ".xbindkeysrc-xsetup" ''
            ${toXbindkeysConfig (xbindkeysFilter { session = false; } xbindkeysConfig.bindings)}
          '';

          xbindkeysRCSession = pkgs.writeText ".xbindkeysrc-xsession" ''
            ${toXbindkeysConfig (xbindkeysFilter { session = true; } xbindkeysConfig.bindings)}
          '';
        in
        {
          setupCommands = with pkgs; ''
            # Setup displays.
            ${xrandrCommands}

            # Setup Fn keys.
            ${procps}/bin/pkill xbindkeys || true
            ${xbindkeys}/bin/xbindkeys --file ${xbindkeysRCSetup}
          '';

          sessionCommands = with pkgs; ''
            # Setup displays.
            ${xrandrCommands}

            # Setup Fn keys.
            ${procps}/bin/pkill xbindkeys || true
            ${xbindkeys}/bin/xbindkeys --file ${xbindkeysRCSession}
          '';
        };

      # Touchpad.
      libinput = {
        enable = true;

        additionalOptions = ''
          MatchIsTouchpad "on"
        '';

        # Enable natural scrolling behavior.
        naturalScrolling = true;
      };
    };

    # SSD.
    # See: https://github.com/NixOS/nixos-hardware/blob/master/common/pc/ssd/default.nix
    # fstrim.enable = true;

    thermald.enable = true;
  };
}
