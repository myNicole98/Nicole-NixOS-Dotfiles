#░█▀▄░█▀▀░█▀▀░█░█░▀█▀░█▀█░█▀█
#░█░█░█▀▀░▀▀█░█▀▄░░█░░█░█░█▀▀
#░▀▀░░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░░

{config, pkgs, pkgs-unstable, lib, inputs, ... }:

{
  # Enable GDM
  #services.xserver.displayManager.gdm = { # 25.05
  services.displayManager.gdm = { # 25.11
    enable = true;
    #autoLogin.enable = true;
    #autoLogin.user = "nicole";
  };

  systemd.services.copyGdmMonitorsXml = {
    description = "Copy monitors.xml to GDM config";
    after = [ "network.target" "systemd-user-sessions.service" "display-manager.service" ];

    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo \"Running copyGdmMonitorsXml service\" && mkdir -p /run/gdm/.config && echo \"Created /run/gdm/.config directory\" && [ \"/home/nicole/.config/monitors.xml\" -ef \"/run/gdm/.config/monitors.xml\" ] || cp /home/nicole/.config/monitors.xml /run/gdm/.config/monitors.xml && echo \"Copied monitors.xml to /run/gdm/.config/monitors.xml\" && chown gdm:gdm /run/gdm/.config/monitors.xml && echo \"Changed ownership of monitors.xml to gdm\"'";
      Type = "oneshot";
    };

wantedBy = [ "multi-user.target" ];
  };
  
  # Enable SDDM
  #services.xserver.displayManager.sddm.enable = true;
  #services.displayManager.sddm.wayland.enable = true;
  #environment.systemPackages = with pkgs; [
  #   kdePackages.qtmultimedia 
  #   libsForQt5.qt5.qtgraphicaleffects
  #   sddm-astronaut
  # ];
  #services.displayManager.sddm.theme = "${pkgs.sddm-chili-theme}/share/sddm/themes/chili";
  #services.displayManager.sddm.wayland.enable = true;

  # Gnome Keyring (for window managers)
  services.gnome.gnome-keyring.enable = true;

  # HYPRLAND #
  #programs.hyprland = {
  #  enable = true;
  #  withUWSM = true;
  #  xwayland.enable = true;
  #};
 
  # NIRI #
  #nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri = {
    #package = pkgs.niri-unstable;
    enable = true;
  };
  
  # MANGO #
  # programs.mango.enable = true;

  # i3
  #services.xserver = {
  #  enable = true;
  #  windowManager.i3 = {
  #    enable = true;
  #    extraPackages = with pkgs; [
  #      dmenu #application launcher most people use
  #      i3status # gives you the default i3 status bar
  #      i3blocks #if you are planning on using i3blocks over i3status
  #   ];
  #  };
  #};
  #programs.i3lock.enable = true; #default i3 screen locker

  # SWAY
  #programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #};

  # GNOME
  #services.desktopManager.gnome.enable = true;
  #environment.gnome.excludePackages = with pkgs; [
  #  baobab      # disk usage analyzer
  #  cheese      # photo booth
  #  eog         # image viewer
  #  epiphany    # web browser
  #  gedit       # text editor
  #  simple-scan # document scanner
  #  totem       # video player
  #  yelp        # help viewer
  #  evince      # document viewer
  #  file-roller # archive manager
  #  geary       # email client
  #  seahorse    # password manager

  #  gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-contacts
  #  gnome-font-viewer gnome-logs gnome-maps gnome-music gnome-photos gnome-screenshot
  #  gnome-system-monitor gnome-weather gnome-disk-utility pkgs.gnome-connections
  #];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
    CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
    CUDA_MODULE_LOADING = "LAZY";
  };

}
