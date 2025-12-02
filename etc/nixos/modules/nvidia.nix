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
      nvidiaSettings = false;

      package = config.boot.kernelPackages.nvidiaPackages.latest;

      #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #  version = "580.95.05";
      #  sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
      #  sha256_aarch64 = "sha256-zLRCbpiik2fGDa+d80wqV3ZV1U1b4lRjzNQJsLLlICk=";
      #  openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
      #  settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
      #  persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
      #};

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
        #"__EGL_VENDOR_LIBRARY_FILENAMES" = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        "__EGL_EXTERNAL_PLATFORM_CONFIG_DIRS" = "/run/opengl-driver/share/egl/egl_external_platform.d";
        "LIBEGL_DRIVERS_PATH" = "/run/opengl-driver/lib/egl";
        "CUDA_CACHE_PATH" = "/home/nicole/.cache/nv";
      };
      #etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".source = ./50-limit-free-buffer-pool.json;
    };
}

