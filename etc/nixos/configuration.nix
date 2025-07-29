{ config, pkgs, pkgs-unstable, lib, inputs, ... }:


#░█░█░█▀▀░█▀▀░█▀▄░░░█░█░█▀█░█▀▄░▀█▀░█▀█░█▀▄░█░░░█▀▀░█▀▀
#░█░█░▀▀█░█▀▀░█▀▄░░░▀▄▀░█▀█░█▀▄░░█░░█▀█░█▀▄░█░░░█▀▀░▀▀█
#░▀▀▀░▀▀▀░▀▀▀░▀░▀░░░░▀░░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀▀▀░▀▀▀


let
  # TO-DO
  user = "nicole";
in


#░▀█▀░█▄█░█▀█░█▀█░█▀▄░▀█▀░█▀▀
#░░█░░█░█░█▀▀░█░█░█▀▄░░█░░▀▀█
#░▀▀▀░▀░▀░▀░░░▀▀▀░▀░▀░░▀░░▀▀▀

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/virtualization.nix
      ./modules/nvidia.nix
      ./modules/desktop.nix
      ./modules/ld-fix.nix
    ];
  

#░█▀▄░█▀█░█▀█░▀█▀░█░░░█▀█░█▀█░█▀▄░█▀▀░█▀▄
#░█▀▄░█░█░█░█░░█░░█░░░█░█░█▀█░█░█░█▀▀░█▀▄
#░▀▀░░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀
  
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot = {
    plymouth = {
      enable = true;
    };
    
    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=0"
      "udev.log_priority=3"
    ];

    kernelPackages = pkgs.linuxPackages_zen;

    loader.timeout = 0;
    loader.systemd-boot.consoleMode = "auto";
  };


#░█▀█░█▀▀░▀█▀░█░█░█▀█░█▀▄░█░█
#░█░█░█▀▀░░█░░█▄█░█░█░█▀▄░█▀▄
#░▀░▀░▀▀▀░░▀░░▀░▀░▀▀▀░▀░▀░▀░▀

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Rome";
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  networking.firewall = { enable = false; }; 


#░█░░░█▀█░█▀▀░█▀█░█░░░█▀▀
#░█░░░█░█░█░░░█▀█░█░░░█▀▀
#░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀


  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  console.keyMap = "us-acentos";



#░█░█░█▀▀░█▀▀░█▀▄
#░█░█░▀▀█░█▀▀░█▀▄
#░▀▀▀░▀▀▀░▀▀▀░▀░▀


  users.users.nicole = {
    isNormalUser = true;
    description = "Nicole";
    extraGroups = [ "networkmanager" "wheel" "libvrtd" "kvm" "qemu-libvirtd" "cdrom" ];
    packages = with pkgs; [];
  };


#░█░█░█▀█░█▀▀░█▀▄░█▀▀░█▀▀
#░█░█░█░█░█▀▀░█▀▄░█▀▀░█▀▀
#░▀▀▀░▀░▀░▀░░░▀░▀░▀▀▀░▀▀▀
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


#░█░█░█▀▄░█▀▀
#░▄▀▄░█░█░█░█
#░▀░▀░▀▀░░▀▀▀


  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];



#░█▀▀░█▀█░█░█░█▀█░█▀▄
#░▀▀█░█░█░█░█░█░█░█░█
#░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀░


  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    #jack.enable = true;
  };



#░█▀█░█▀█░█▀▀░█░█░█▀█░█▀▀░█▀▀░█▀▀
#░█▀▀░█▀█░█░░░█▀▄░█▀█░█░█░█▀▀░▀▀█
#░▀░░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀

  environment.systemPackages = with pkgs; [
    # TERM UTILS #
    kitty
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
    pkgs-unstable.hyprlock
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
    onlyoffice-desktopeditors
    obsidian
    nextcloud-client
    xournalpp
    gnome-text-editor
    gnome-calculator
    simple-scan
    anydesk
    gimp

    # MEDIA #
    ffmpeg
    mpv
    jellyfin-media-player
    feishin
    spotify

    # INTERNET #    
    floorp
    brave
    telegram-desktop
    element-desktop
    (discord.override {
      withVencord = true;
    })
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
    #home-manager
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
  
  # ISO mounting utils #
  programs.cdemu.enable = true;
  
  # KDE Connect
  programs.kdeconnect.enable = true;

  # OLLAMA #
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    package = pkgs.ollama;
    environmentVariables = {
      CUDA_VISIBLE_DEVICES = "0";
      NVIDIA_VISIBLE_DEVICES = "all";
     LD_LIBRARY_PATH = "${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.cudatoolkit}/lib64";
    };
  };

  /*
  # GTK DARK THEME #
  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      settings = with lib.gvariant; {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "adw-gtk3-dark";
          };
        };
      }];
    };

  nixpkgs.overlays = [
    (final: prev:
    {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
      });
    })
  ];
  */
  
  # STEAM #
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable =  true;
 
  # DEFAULTS #
  environment = {
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "floorp";
      TERMINAL = "kitty";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      NIXOS_OZONE_WL = "1";
    };
    #etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".source = ./50-limit-free-buffer-pool.json;
  };

  # Fonts with emojis uwu #
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  services.gvfs.enable = true;
  programs.dconf.enable = true;
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  environment.pathsToLink = [ "/share/nautilus-python/extensions" ];
  environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";

  
  system.stateVersion = "25.11";
  
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
  dates = "02:00";
  randomizedDelaySec = "45min";
  };

}
