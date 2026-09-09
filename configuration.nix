{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/locale.nix
    ./modules/users.nix
    ./modules/desktop.nix
    ./modules/nvidia.nix
    ./modules/shell.nix
    ./modules/dev.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # lts kernel: nvidia modules lag mainline and a miss blocks every rebuild
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "Matrix";

  # connections configured with nmcli or nmtui
  networking.networkmanager.enable = true;

  # devices paired with bluetoothctl
  hardware.bluetooth.enable = true;

  nixpkgs.config.allowUnfree = true;

  # never change, pins app data compat and not package versions
  system.stateVersion = "26.05";
}
