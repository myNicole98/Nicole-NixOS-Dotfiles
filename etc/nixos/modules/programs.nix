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
    xwayland-satellite

    # OFFICE #
    obsidian
    nextcloud-client
    xournalpp
    gnome-text-editor
    gnome-calculator
    simple-scan
    anydesk

    # PRODUCTION #
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
    geary
    tutanota-desktop
    teams-for-linux
    qbittorrent
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
    mission-center
    xdg-user-dirs
    brightnessctl
    pkgs-unstable.openrgb
    dmg2img
    
    # CUDA #
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_cudart

    # AI #
    pkgs-unstable.jan

    # AUDIO AND DAW#
    helvum
    reaper
    a2jmidid
    bitwig-studio
    yabridge
    yabridgectl
    alsa-scarlett-gui
    qjackctl

    # WINE #
    wineWowPackages.stable
    winetricks
  ];

  # Enable Flaktpak
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "org.pitivi.Pitivi"
    "app.zen_browser.zen"
    "org.blender.Blender"
    "org.onlyoffice.desktopeditors"
    "com.rustdesk.RustDesk"
    "org.gimp.GIMP"
  ];


services.hardware.openrgb.enable = true;
}

