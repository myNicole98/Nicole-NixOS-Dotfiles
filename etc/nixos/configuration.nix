{ config, pkgs, pkgs-unstable, lib, ... }:


#░█░█░█▀▀░█▀▀░█▀▄░░░█░█░█▀█░█▀▄░▀█▀░█▀█░█▀▄░█░░░█▀▀░█▀▀
#░█░█░▀▀█░█▀▀░█▀▄░░░▀▄▀░█▀█░█▀▄░░█░░█▀█░█▀▄░█░░░█▀▀░▀▀█
#░▀▀▀░▀▀▀░▀▀▀░▀░▀░░░░▀░░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀▀▀░▀▀▀


let
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
  services.udev.extraRules = ''
        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  boot = {
    plymouth = {
      enable = true;
    };
    
    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelModules = ["i2c-dev"];
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=0"
      "udev.log_priority=3"
    ];

    kernelPackages = pkgs.linuxPackages_latest;

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
    extraGroups = [ "networkmanager" "wheel" "libvrtd" "kvm" "qemu-libvirtd" "i2c"];
    packages = with pkgs; [];
  };

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";


#░█░█░█▀█░█▀▀░█▀▄░█▀▀░█▀▀
#░█░█░█░█░█▀▀░█▀▄░█▀▀░█▀▀
#░▀▀▀░▀░▀░▀░░░▀░▀░▀▀▀░▀▀▀
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];



#░█░░░█▀▄░░░█▀▀░▀█▀░█░█
#░█░░░█░█░░░█▀▀░░█░░▄▀▄
#░▀▀▀░▀▀░░░░▀░░░▀▀▀░▀░▀

  #programs.nix-ld.enable = true;
  #programs.nix-ld.libraries = with pkgs ; [
  #  gcc-unwrapped
  #  stdenv.cc.cc.lib
  #  libz
  #  cairo
  #  pango
  #];


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
    nemo-with-extensions
    gvfs
    nautilus
    nautilus-python
    sushi
    fsearch

    # SCREENSHOTS AND RECORDING #
    grim
    slurp
    swappy 
    wl-clipboard
    obs-studio

    # HYPRLAND RELATED #
    hyprpaper
    pkgs-unstable.hyprlock
    swaylock
    hypridle
    hyprpanel
    hyprpolkitagent
    waybar
    wlogout
    rofi-wayland
    libnotify
    ags
    
    # OFFICE #
    onlyoffice-desktopeditors
    obsidian
    siyuan
    nextcloud-client
    xournalpp
    gnome-text-editor
    gnome-calculator

    # MEDIA #
    ffmpeg
    mpv
    jellyfin-media-player
    resonance

    # INTERNET #    
    floorp
    telegram-desktop
    element-desktop
    discord
    mailspring
    wasistlos
    teams-for-linux
    qbittorrent
    
    # DEV #
    vscode-fhs
    nixd
    nil
    #python312
    #python312Packages.pip
    zed-editor
    gnumake
    cmake
    ninja
    #python3
    libgcc
    gcc

    # GAMING #
    mangohud
    lutris
    protonup-qt
    gdlauncher-carbon

    # OTHERS #
    home-manager
    nwg-look
    seahorse
    playerctl
    adw-gtk3
    remmina
    deskreen

    # UTILS #
    monitorets
    xdg-user-dirs
    brightnessctl
    
    # CUDA #
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_cudart

    # AUDIO #
    helvum



    
  ];
 
  # OLLAMA #
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    package = pkgs-unstable.ollama;
    environmentVariables = {
      CUDA_VISIBLE_DEVICES = "0";
      NVIDIA_VISIBLE_DEVICES = "all";
     LD_LIBRARY_PATH = "${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.cudatoolkit}/lib64";
    };
  };

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

  
  # STEAM #
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable =  true;
  
  environment = {
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };
    #etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".source = ./50-limit-free-buffer-pool.json;
  };


  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  system.stateVersion = "24.11";

}
