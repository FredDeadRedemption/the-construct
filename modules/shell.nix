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
    pciutils
    usbutils
  ];

  services.openssh.enable = true;
}
