#░█▀█░█▀█░█▀▀░█░█░█▀█░█▀▀░█▀▀░█▀▀
#░█▀▀░█▀█░█░░░█▀▄░█▀█░█░█░█▀▀░▀▀█
#░▀░░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀

{config, pkgs, pkgs-unstable, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # TERM UTILS #
    neovim
    wget
    git
    fastfetch
    htop
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
    swaylock
    hypridle
    hyprpanel
    hyprsunset
    hyprpolkitagent
    waybar
    hyprpanel
    wlogout
    rofi-wayland
    libnotify
    
    # OFFICE #
    pkgs-unstable.onlyoffice-desktopeditors
    obsidian
    nextcloud-client
    xournalpp
    gnome-text-editor
    gnome-calculator
    simple-scan
    anydesk

    # MEDIA EDITORS #
    gimp
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
    teams-for-linux
    qbittorrent
    
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
    gnome-system-monitor
    xdg-user-dirs
    brightnessctl
    
    # CUDA #
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_cudart

    # AUDIO #
    helvum
  ];

  # Enable Flaktpak
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "org.pitivi.Pitivi"
    "app.zen_browser.zen"
  ];
}
