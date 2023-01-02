#
# Osier.
#

{ config, pkgs, lib, ... }:

{
  # Imports.
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot.
  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.cleanTmpDir = true; # Delete all files in `/tmp` during boot.

  # Networking.
  networking.hostName = "osier";
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  # Firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
    ];
    # allowedUDPPorts = [ ... ];
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Users.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = []
      ++ lib.optional (builtins.pathExists ./id_rsa.cashapona.pub) ./id_rsa.cashapona.pub;
  };

  users.users.superpaintman = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = []
      ++ lib.optional (builtins.pathExists ./id_rsa.cashapona.pub) ./id_rsa.cashapona.pub;
  };

  # Environment.
  environment.systemPackages = with pkgs; [
    vim
    wirelesstools
  ];

  # OpenSSH.
  services.openssh = {
    enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
