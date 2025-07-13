{ config, pkgs, lib, ... }:


{
  boot = {
    kernelParams = [
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_UsePageAttributeTable=1"
      "nvidia_modeset.disable_vrr_memclk_switch=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    ];
    blacklistedKernelModules = ["nouveau"];
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = true;
      gsp.enable = config.hardware.nvidia.open; 
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.latest;
      videoAcceleration = true;
    };
  };

    environment = {
      sessionVariables = {
        "__EGL_VENDOR_LIBRARY_FILENAMES" = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";
        "CUDA_CACHE_PATH" = "/home/nicole/.cache/nv";
      };
      etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".source = ./50-limit-free-buffer-pool.json;
    };
}
