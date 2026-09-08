# Command-line environment and system services.

{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    claude-code
    git
    wget
    curl
    ripgrep
    fd
    htop
    pciutils   # lspci — was missing when identifying the GPUs
    usbutils
  ];

  services.openssh.enable = true;
}
