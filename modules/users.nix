{ config, lib, pkgs, ... }:

{
  users.users.fred = {
    isNormalUser = true;
    description = "Fred";
    # video for brightnessctl, input for some devices
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    packages = with pkgs; [
      tree
    ];
  };
}
