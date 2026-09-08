# Hybrid graphics: Intel iGPU (PCI 0:2:0) + NVIDIA dGPU (PCI 1:0:0).
#
# Configured for PRIME *offload*: the compositor and everything else render on
# the Intel iGPU and the NVIDIA card stays powered down until a program is
# explicitly launched with `nvidia-offload`. Best battery life, at the cost
# that display outputs wired to the dGPU may not work — see the note at the
# bottom if an external monitor stays dark.

{ config, lib, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Steam, wine, anything 32-bit
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Blackwell-generation cards are only supported by the open kernel
    # modules; the closed ones do not build for this GPU.
    open = true;

    # Required for Wayland. Without it the compositor cannot use the card
    # and you get a black screen on any dGPU-driven output.
    modesetting.enable = true;

    # Lets the dGPU actually power down when idle, which is the entire point
    # of an offload setup on a laptop.
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        # Provides the `nvidia-offload` wrapper, e.g. `nvidia-offload steam`.
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # If an external monitor connected over HDMI/USB-C stays black, that port is
  # wired to the NVIDIA card and offload cannot drive it. Swap the whole
  # `prime` block above for:
  #
  #   prime = {
  #     sync.enable = true;
  #     intelBusId = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:1:0:0";
  #   };
  #
  # Everything then renders on the dGPU, at a noticeable battery cost.
}
