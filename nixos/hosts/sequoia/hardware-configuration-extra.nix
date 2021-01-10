{ config, pkgs, ... }:

{
  # Boot.
  boot.loader = {
    # Use the systemd-boot EFI boot loader.
    systemd-boot.enable = true;

    efi.canTouchEfiVariables = true;
  };

  # Networking.
  networking = {
    useDHCP = false;

    interfaces.eno1.useDHCP = true;
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
    };

    bluetooth = {
      enable = true;
    };
  };

  # Nix Packages.
  # Allow unfree for Nvidia drivers.
  nixpkgs.config.allowUnfree = true;

  # Services.
  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];

      # Display manager.
      displayManager =
        let
          xrandrCommands = with pkgs; ''
            ${xorg.xrandr}/bin/xrandr --output DVI-D-0 --left-of DVI-I-1
          '';
        in
        {
          setupCommands = ''
            # Setup displays.
            ${xrandrCommands}
          '';

          sessionCommands = ''
            # Setup displays.
            ${xrandrCommands}
          '';
        };
    };
  };
}
