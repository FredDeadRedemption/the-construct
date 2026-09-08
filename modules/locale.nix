# Timezone, console and keyboard layout.

{ config, lib, pkgs, ... }:

{
  time.timeZone = "Europe/Copenhagen";

  # i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "ter-v28n";
    keyMap = "dk";
    earlySetup = true;
  };

  console.packages = with pkgs; [ kbd terminus_font ];

  # Danish layout for the graphical session. niri reads this via xkb, so
  # this single option covers both the TTY (above) and Wayland.
  services.xserver.xkb = {
    layout = "dk";
    # options = "caps:escape";
  };
}
