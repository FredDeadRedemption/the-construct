{ config, lib, pkgs, ... }:

{
  time.timeZone = "Europe/Copenhagen";

  console = {
    font = "ter-v28n";
    keyMap = "dk";
    earlySetup = true;
  };

  console.packages = with pkgs; [ kbd terminus_font ];

  # niri reads xkb, so this covers wayland too
  services.xserver.xkb.layout = "dk";
}
