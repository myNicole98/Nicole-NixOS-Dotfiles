{ config, pkgs, inputs, ... }:

{
  imports = [
    ./theme.nix
    ./firefox.nix
    ./dms.nix
    inputs.zen-browser.homeModules.twilight
  ];

  home.username = "nicole";
  home.homeDirectory = "/home/nicole";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    kdePackages.qt5compat
    rose-pine-cursor
  ];

  programs.zen-browser.enable = true;

  services.linux-wallpaperengine = {
    enable = false;
    assetsPath = "/mnt/storage/SteamLibrary/steamapps/common/wallpaper_engine/assets";
  };
}
