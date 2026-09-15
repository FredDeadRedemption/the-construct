# thinkpad hybrid usb-c dock carries video over displaylink, not dp alt mode

{ config, lib, pkgs, ... }:

{
  # nixos keys the whole displaylink stack off this entry: evdi module, udev rules, dlm service
  services.xserver.videoDrivers = [ "displaylink" ];
}
