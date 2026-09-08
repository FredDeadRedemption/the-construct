# prime offload: intel renders everything, dgpu idle until nvidia-offload

{ config, lib, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # blackwell only builds with the open modules
    open = true;

    # required for wayland
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        # provides the nvidia-offload wrapper
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # external display staying black means it is wired to the dgpu, swap prime for sync.enable
}
