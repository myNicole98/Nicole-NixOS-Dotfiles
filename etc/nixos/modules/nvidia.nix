{ config, pkgs, lib, ... }:

let 

package = config.boot.kernelPackages.nvidiaPackages.latest;

in
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
      #package = config.boot.kernelPackages.nvidiaPackages.latest;
      
      #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #  version = "580.173.02";
      #  sha256_64bit = "sha256-jY65AB4FqaimY9PV0wT+tk7yhE7hhczf2VJ4aCD0bhs=";
      #  openSha256 = "sha256-lhloZdf6XbaAFTZBF1DxE0Nv9VC6obY8UPf0VyfVepE=";
      #  usePersistenced = false;
      #  useSettings = false;
      #};

      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "610.57.04";
        sha256_64bit = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
        openSha256 = "sha256-rQHOOOY4KL92Ww3KDwh+j4eGU7oNAH8LutZC5wmFnPo=";
        usePersistenced = false;
        useSettings = false;
      };
    };
  };

    environment = {
      sessionVariables = {
        #"__EGL_VENDOR_LIBRARY_FILENAMES" = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";
        #"__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        #"__EGL_EXTERNAL_PLATFORM_CONFIG_DIRS" = "/run/opengl-driver/share/egl/egl_external_platform.d";
        #"LIBEGL_DRIVERS_PATH" = "/run/opengl-driver/lib/egl";
        "CUDA_CACHE_PATH" = "/home/nicole/.cache/nv";
      };
      #etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".source = ./50-limit-free-buffer-pool.json;
    };
}

