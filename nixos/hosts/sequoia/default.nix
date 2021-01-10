#
# Sequoia.
#

{ config, pkgs, ... }:

{
  # Imports.
  imports = [
    # Hardware.
    ./hardware-configuration.nix
    ./hardware-configuration-extra.nix

    # Include common config.
    ../../.
  ];

  # Networking.
  networking.hostName = "sequoia";
  networking.networkmanager.enable = true;

  # Time.
  time.timeZone = "Europe/Moscow";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
