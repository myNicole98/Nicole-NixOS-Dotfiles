#░█▀▄░█▀▀░█▀▀░█░█░▀█▀░█▀█░█▀█
#░█░█░█▀▀░▀▀█░█▀▄░░█░░█░█░█▀▀
#░▀▀░░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░░

{config, pkgs, pkgs-unstable, lib, inputs, ... }:

{
  # Gnome Keyring (for window managers) 
  services.gnome.gnome-keyring.enable = true;
  
  # ENV VARS #
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
    CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
    CUDA_MODULE_LOADING = "LAZY";
  };
}
