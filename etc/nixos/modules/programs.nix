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
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};

in

{
#░█▀█░█▀█░█▀▀░█░█░█▀█░█▀▀░█▀▀░█▀▀
#░█▀▀░█▀█░█░░░█▀▄░█▀█░█░█░█▀▀░▀▀█
#░▀░░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
    "mbedtls-2.28.10"
    "ventoy-1.1.10"
  ];
  
  # Defined Programs
  environment.systemPackages = with pkgs; [
    # TERM UTILS #
    neovim
    kitty
    wget
    git
    fastfetch
    htop
    btop-cuda
    cowsay
    starship
    cava
    vulkan-tools
    zip
    jq
    libsecret
    ventoy-full


    # FILES #
    gvfs
    nautilus
    nautilus-python
    nautilus-open-any-terminal
    sushi
    pandoc
    texliveFull
    fsearch
    pkgs-unstable.dsearch
    filezilla
    ffmpegthumbnailer
    zenity
    imagemagick

    # SCREENSHOTS AND RECORDING #
    grim
    slurp
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
    jellyfin-mpv-shim

    # INTERNET #
    pkgs-unstable._64gram
    element-desktop
    wasistlos
    vesktop
    pkgs-unstable.mailspring
    pkgs-unstable.thunderbird
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
    pkgs-unstable.protonplus
    gdlauncher-carbon
    lug-helper

    # OTHERS #
    seahorse
    playerctl
    adw-gtk3
    remmina
    appimage-run
    gnomeExtensions.appindicator
    pywalfox-native
    linux-wallpaperengine

    # UTILS #
    monitorets
    mission-center
    xdg-user-dirs
    brightnessctl
    dmg2img
    cachix
    pkgs-unstable.rbw
    pinentry-tty
    pkgs-unstable.kando
    gearlever
    bitwarden-desktop
    
    # CUDA #
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_cudart

    # AI #
    (callPackage ./pkgs/msty/default.nix {}) 
    pkgs-unstable.lmstudio
    pkgs-unstable.opencode
    #inputs.opencode.packages.${pkgs.system}.default

    # AUDIO AND DAW#
    helvum
    reaper
    a2jmidid
    bitwig-studio
    yabridge
    yabridgectl
    alsa-utils

    # WINE #
    wineWowPackages.stable
    winetricks
    bottles

    # CAD&3D #
    orca-slicer-fixed
    (callPackage ./pkgs/anycubic-slicer-next/default.nix {})
  ];

  # STEAM #
  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam;
    #gamescopeSession.enable = true;
  };
  programs.gamemode.enable =  true;

  # ISO mounting utils #
  programs.cdemu.enable = true;
  
  # KDE Connect
  programs.kdeconnect.enable = true;

  # OPENRGB #
  services.hardware.openrgb = { 
    enable = true; 
    package = pkgs-unstable.openrgb-with-all-plugins; 
  };
  
  # SPICETIFY #
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle # shuffle+ (special characters are sanitized out of extension names)
    ];
    #theme = spicePkgs.themes.sleek;
    #colorScheme = "matugen";
  };
  
  # DOCKER #
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

