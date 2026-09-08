{ config, lib, pkgs, ... }:

{
  programs.niri.enable = true;

  # niri module already brings polkit, dconf, gnome-keyring, portals, session entry
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-user-session --asterisks --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      user = "greeter";
    };
  };

  # without Type=idle the boot log paints over the greeter
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    # apps that still speak the pulseaudio api
    pulse.enable = true;
  };

  # realtime priority for pipewire and the compositor
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

  # dark mode, one mechanism per toolkit

  # portal reports this over org.freedesktop.appearance; firefox, chromium, electron, gtk4 follow
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
      };
    }
  ];

  # gtk3 predates the portal; /etc/xdg is a default so user config still wins
  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Adwaita-dark
  '';

  # qt ignores the portal without the gnome plugin
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.systemPackages = with pkgs; [
    # niri ships no terminal, launcher, bar or notification daemon
    alacritty
    fuzzel
    waybar
    mako
    swaylock
    chromium
    signal-desktop
    reaper

    # niri has no xwayland; niri config spawns this at startup
    xwayland-satellite

    # wayland utils
    wl-clipboard
    cliphist
    swaybg
    grim
    slurp
    brightnessctl
    playerctl
    pavucontrol
    nautilus

    # gtk3 adwaita-dark theme; gtk4 has dark built in
    gnome-themes-extra
  ];

  # electron and chromium on wayland instead of xwayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.firefox.enable = true;
  programs.steam.enable = true;
}
