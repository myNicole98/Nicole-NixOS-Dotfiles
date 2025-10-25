#░█▀█░█▀█░█▀▀░█░█░█▀█░█▀▀░█▀▀░█▀▀
#░█▀▀░█▀█░█░░░█▀▄░█▀█░█░█░█▀▀░▀▀█
#░▀░░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀

{config, pkgs, pkgs-unstable, lib, ... }:

{
  
  # RISKY, REMOVE ASAP ###
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
    "mbedtls-2.28.10"
  ];

  # Defined Programs
  environment.systemPackages = with pkgs; [
    # TERM UTILS #
    neovim
    wget
    git
    fastfetch
    htop
    btop-cuda
    cowsay
    starship
    cava

    # FILES #
    gvfs
    nautilus
    nautilus-python
    nautilus-open-any-terminal
    sushi
    pandoc
    texliveFull
    fsearch
    filezilla
    ffmpegthumbnailer
    zenity
    imagemagick

    # SCREENSHOTS AND RECORDING #
    grim
    slurp
    swappy 
    wl-clipboard
    obs-studio

    # HYPRLAND RELATED #
    hyprpaper
    swaybg
    hyprlock
    hypridle
    hyprpanel
    hyprsunset
    hyprpolkitagent
    waybar
    hyprpanel
    wlogout
    rofi
    libnotify
    wayvnc
    #pkgs-unstable.quickshell
    xwayland-satellite
    #inputs.quickshell.packages.${pkgs.system}.default

    # OFFICE #
    pkgs-unstable.onlyoffice-desktopeditors
    obsidian
    nextcloud-client
    xournalpp
    gnome-text-editor
    gnome-calculator
    simple-scan
    anydesk

    # PRODUCTION #
    #gimp
    pinta

    # MEDIA #
    ffmpeg
    mpv
    jellyfin-media-player
    feishin
    spotify

    # INTERNET #
    telegram-desktop
    element-desktop
    vesktop
    mailspring
    geary
    tutanota-desktop
    teams-for-linux
    qbittorrent
    #rustdesk
    sunshine
    
    # DEV #
    vscode-fhs
    nixd
    nil
    zed-editor
    gnumake
    cmake
    ninja
    libgcc
    gcc

    # GAMING #
    mangohud
    lutris
    protonup-qt
    gdlauncher-carbon
    adwsteamgtk

    # OTHERS #
    seahorse
    playerctl
    adw-gtk3
    remmina
    appimage-run
    gnomeExtensions.appindicator

    # UTILS #
    monitorets
    #gnome-system-monitor
    mission-center
    xdg-user-dirs
    brightnessctl
    pkgs-unstable.openrgb
    dmg2img
    
    # CUDA #
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_cudart

    # AUDIO AND DAW#
    helvum
    reaper
    a2jmidid
    bitwig-studio
    #carla
    yabridge
    yabridgectl
    alsa-scarlett-gui
    qjackctl

    # WINE #
    wineWowPackages.stable
    #wineWowPackages.waylandFull
    winetricks
  ];

  # Enable Flaktpak
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "org.pitivi.Pitivi"
    "app.zen_browser.zen"
    "org.blender.Blender"
  ];


services.hardware.openrgb.enable = true;
}

