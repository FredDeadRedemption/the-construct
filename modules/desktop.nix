# Graphical session: niri (scrollable-tiling Wayland compositor), audio,
# fonts, and the handful of programs a bare compositor does not supply.

{ config, lib, pkgs, ... }:

{
  programs.niri.enable = true;

  # The niri module already pulls in: polkit, dconf, gnome-keyring,
  # xdg-desktop-portal-{gnome,gtk}, the systemd user units, and the
  # wayland-session entry the display manager lists. Don't re-declare those.

  # Login manager. greetd is a minimal daemon; tuigreet is a text greeter that
  # runs on the TTY, so nothing X11 is dragged in. It lists every session
  # registered by services.displayManager.sessionPackages, which niri populates.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-user-session --asterisks --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      user = "greeter";
    };
  };

  # tuigreet draws on the TTY greetd hands it; without this the boot log
  # keeps painting over the greeter.
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # Audio. pipewire replaces pulseaudio; pulse.enable provides the PA API
  # that most applications still speak.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Lets pipewire and the compositor request realtime priority.
  security.rtkit.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  environment.systemPackages = with pkgs; [
    # niri ships no terminal, launcher, bar or notification daemon. Without
    # at least a terminal you get a working compositor and no way to open
    # anything in it.
    alacritty
    fuzzel
    waybar
    mako
    swaylock
    chromium

    # niri is built without XWayland; this supplies it as a side process for
    # X11-only apps. Started from the niri config via spawn-at-startup.
    xwayland-satellite

    # Wayland odds and ends: clipboard, screenshots, brightness, volume,
    # and a GUI file manager for the portal file chooser.
    wl-clipboard
    grim
    slurp
    brightnessctl
    playerctl
    pavucontrol
    nautilus
  ];

  # Make Electron/Chromium apps run natively on Wayland instead of XWayland.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.firefox.enable = true;
}
