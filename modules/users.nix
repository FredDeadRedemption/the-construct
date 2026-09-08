# User accounts.

{ config, lib, pkgs, ... }:

{
  users.users.fred = {
    isNormalUser = true;
    description = "Fred";
    # video/input are needed for brightness control and some input devices.
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    packages = with pkgs; [
      tree
    ];
  };
}
