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
    fastfetch
    ffmpeg
    nmap
    wireguard-tools
  ];

  services.openssh.enable = true;
  services.netbird.enable = true;
}
