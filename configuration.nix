# Machine-level configuration for "Matrix".
# Everything topic-specific lives in ./modules — see the NixOS manual
# (`nixos-help`) and https://search.nixos.org/options for available options.

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/locale.nix
    ./modules/users.nix
    ./modules/desktop.nix
    ./modules/nvidia.nix
    ./modules/shell.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LTS kernel rather than linuxPackages_latest: the NVIDIA kernel modules
  # regularly lag the newest mainline release, and when they do the build
  # fails outright and blocks every rebuild until upstream catches up.
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "Matrix";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # This option defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application
  # data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for
  # any reason, even if you've upgraded your system to a new NixOS release.
  system.stateVersion = "26.05"; # Did you read the comment?
}
