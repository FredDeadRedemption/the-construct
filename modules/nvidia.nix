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
    powerManagement.finegrained = false;

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

  # finegrained=false only drops the param; 0x03 default still picks rtd3 on ampere+ laptops
  boot.extraModprobeConfig = "options nvidia NVreg_DynamicPowerManagement=0x00";

  # external display staying black means it is wired to the dgpu, swap prime for sync.enable
}
