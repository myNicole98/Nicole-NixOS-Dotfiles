{ config, pkgs, ... }:
{
  services.xserver.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  environment.systemPackages = with pkgs; [
     kdePackages.qtmultimedia 
     libsForQt5.qt5.qtgraphicaleffects
     sddm-astronaut
   ];
  services.displayManager.sddm.theme = "${pkgs.sddm-chili-theme}/share/sddm/themes/chili";
  services.displayManager.sddm.wayland.enable = true;
}
