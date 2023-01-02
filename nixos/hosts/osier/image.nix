{ pkgs, lib, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  ];

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

  # Users.
  users.users.root = {
    initialPassword = "root";
    openssh.authorizedKeys.keyFiles = []
      ++ lib.optional (builtins.pathExists ./id_rsa.cashapona.pub) ./id_rsa.cashapona.pub;
  };

  # Environment.
  environment.systemPackages = with pkgs; [
    vim
    wirelesstools

    # Docker.
    docker

    # UniFi.
    unifiLTS
    jre8
    mongodb
  ];

  # OpenSSH.
  services.openssh.enable = true;

  # Nix Packages.
  # Allow unfree for UniFi.
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "22.11";
}
