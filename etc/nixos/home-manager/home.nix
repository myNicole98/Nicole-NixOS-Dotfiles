{ config, pkgs, inputs, ... }:

{
  imports = [
    ./theme.nix
    ./firefox.nix
    ./dms.nix
    inputs.zen-browser.homeModules.twilight
    inputs.lazyvim.homeManagerModules.default
  ];

  home.username = "nicole";
  home.homeDirectory = "/home/nicole";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    kdePackages.qt5compat
    rose-pine-cursor
  ];
  
  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;   # see caveat below
    desktop     = "/mnt/storage/Desktop";
    documents   = "/mnt/storage/Documents";
    music       = "/mnt/storage/Music";
    pictures    = "/mnt/storage/Pictures";
    videos      = "/mnt/storage/Videos";
    templates   = "/mnt/storage/Templates";
    publicShare = "/mnt/storage/Public";
  };

  programs.zen-browser.enable = true;
  
  programs.lazyvim = {
    enable = true;
      plugins = {
        base46 = ''
          return {
              "duxlabs-dev/base46",
              lazy = false,
              opts = {},
            }
        '';
        colorscheme = ''
          return {
            { "LazyVim/LazyVim", opts = { colorscheme = "dms" } },
          }
        '';
      };
  };
  services.linux-wallpaperengine = {
    enable = false;
    assetsPath = "/mnt/storage/SteamLibrary/steamapps/common/wallpaper_engine/assets";
  };
}
