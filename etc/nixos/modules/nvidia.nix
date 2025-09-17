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
      open = false;
      gsp.enable = config.hardware.nvidia.open; 
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaSettings = false;

      package = config.boot.kernelPackages.nvidiaPackages.latest;
      #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #    version = "575.64.03";
      #    sha256_64bit = "sha256-S7eqhgBLLtKZx9QwoGIsXJAyfOOspPbppTHUxB06DKA=";
      #    openSha256 = "sha256-SAl1+XH4ghz8iix95hcuJ/EVqt6ylyzFAao0mLeMmMI=";
      #    usePersistenced = false;
      #    useSettings = false;
      #  };
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
