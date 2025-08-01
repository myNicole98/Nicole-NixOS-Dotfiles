#░█▀▄░█▀▀░█▀▀░█░█░▀█▀░█▀█░█▀█
#░█░█░█▀▀░▀▀█░█▀▄░░█░░█░█░█▀▀
#░▀▀░░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░░

{config, pkgs, pkgs-unstable, lib, ... }:
{
  
  # Enable GDM
  #services.displayManager.gdm.enable = true;
  
  # Enable SDDM
  services.displayManager.sddm.enable = true;
  environment.systemPackages = with pkgs; [
     kdePackages.qtmultimedia 
     libsForQt5.qt5.qtgraphicaleffects
     sddm-astronaut
   ];
  services.displayManager.sddm.theme = "${pkgs.sddm-chili-theme}/share/sddm/themes/chili";
  services.displayManager.sddm.wayland.enable = true;

  # Gnome Keyring (for window managers)
  services.gnome.gnome-keyring.enable = true;

  # HYPRLAND #
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  
  # SWAY
  #programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #};

  # GNOME
  #services.desktopManager.gnome.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
    CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
    CUDA_MODULE_LOADING = "LAZY";
  };

}
