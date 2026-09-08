{ config, lib, pkgs, ... }:

{
  users.users.fred = {
    isNormalUser = true;
    description = "Fred";
    # video for brightnessctl, input for some devices
    # docker group is root-equivalent
    extraGroups = [ "wheel" "networkmanager" "video" "input" "docker" ];
    packages = with pkgs; [
      tree
    ];
  };
}
