#░█▀█░█▀█░█▀▀░█░█░█▀█░█▀▀░█▀▀░█▀▀
#░█▀▀░█▀█░█░░░█▀▄░█▀█░█░█░█▀▀░▀▀█
#░▀░░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀

{config, pkgs, pkgs-unstable, lib, inputs, ... }:

let

  orca-slicer-fixed = pkgs.symlinkJoin {
    name = "orca-slicer";
    paths = [ pkgs.orca-slicer ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      # Wrap the binary
      wrapProgram $out/bin/orca-slicer \
        --set __GLX_VENDOR_LIBRARY_NAME mesa \
        --set __EGL_VENDOR_LIBRARY_FILENAMES "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json" \
        --set MESA_LOADER_DRIVER_OVERRIDE zink \
        --set GALLIUM_DRIVER zink \
        --set WEBKIT_DISABLE_DMABUF_RENDERER 1
      
      # Fix the desktop entry to point to the wrapped binary
      if [ -f $out/share/applications/orca-slicer.desktop ]; then
        substituteInPlace $out/share/applications/orca-slicer.desktop \
          --replace "Exec=orca-slicer" "Exec=$out/bin/orca-slicer"
      fi
    '';
  };

in

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
    vulkan-tools

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
    #swappy
    satty
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
    #xwayland-satellite
    (callPackage ./pkgs/xwayland-satellite/default.nix {}) 
    xwayland-run

    # OFFICE #
    obsidian
    nextcloud-client
    xournalpp
    gnome-text-editor
    gnome-calculator
    simple-scan

    # MEDIA EDITING #
    pinta
    pkgs-unstable.davinci-resolve

    # MEDIA #
    ffmpeg
    mpv
    feishin
    spotify
    # jellyfin-media-player
    jellyfin-mpv-shim

    # INTERNET #
    telegram-desktop
    element-desktop
    wasistlos
    vesktop
    #geary
    pkgs-unstable.mailspring
    #pkgs-unstable.thunderbird
    #tutanota-desktop
    pkgs-unstable.protonmail-desktop
    teams-for-linux
    qbittorrent
    sunshine 
    
    # DEV #
    vscode-fhs
    nixd
    nil
    pkgs-unstable.zed-editor
    gnumake
    cmake
    ninja
    libgcc
    gcc
    uv
    nodejs_24
    dbgate

    # GAMING #
    mangohud
    lutris
    #heroic
    #protonup-qt
    pkgs-unstable.protonplus
    gdlauncher-carbon
    adwsteamgtk
    lug-helper

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
    cachix
    rbw
    pinentry-tty
    kando
    
    # CUDA #
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_cudart

    # AI #
    (callPackage ./pkgs/msty/default.nix {}) 
    #pkgs-unstable.jan
    #claude-code
    pkgs-unstable.lmstudio
    #(inputs.opencode.packages.${system}.default)
    pkgs-unstable.opencode
    #pkgs-unstable.codex
    #pkgs-unstable.gemini-cli

    # AUDIO AND DAW#
    helvum
    reaper
    a2jmidid
    bitwig-studio
    yabridge
    yabridgectl
    # alsa-scarlett-gui
    # qjackctl
    alsa-utils
    #vital
    (callPackage ./pkgs/vital-stable/default.nix {})

    # WINE #
    wineWowPackages.stable
    #wineWowPackages.waylandFull
    #wineWowPackages.staging
    winetricks

    # CAD&3D #
    orca-slicer-fixed
    #freecad
    (callPackage ./pkgs/anycubic-slicer-next/default.nix {})
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
    "com.anydesk.Anydesk"
    "com.github.iwalton3.jellyfin-media-player"
    "com.sweethome3d.Sweethome3d"
  ];

services.hardware.openrgb.enable = true;

virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;
};

  security.pam.loginLimits = [{
    domain = "nicole";
    type = "hard";
    item = "nofile";
    value = "524288";
  }];
}

