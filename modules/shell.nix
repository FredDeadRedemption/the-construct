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

  # nix-direnv layer caches the shell and keeps the store paths alive against gc
  programs.direnv.enable = true;

  services.openssh.enable = true;
  services.netbird.enable = true;
}
