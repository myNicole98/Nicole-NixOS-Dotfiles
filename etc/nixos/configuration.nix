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
      ./modules/desktop.nix
      ./modules/nvidia.nix
      ./modules/ld-fix.nix
      ./modules/programs.nix
      ./modules/bluetooth.nix
      ./modules/KawaiCA49.nix
      ./cachix.nix
    ];

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/fc0150d8-4f57-4d95-abe9-4b979336b3ce";
    fsType = "ext4";
  };


#░█▀▄░█▀█░█▀█░▀█▀░█░░░█▀█░█▀█░█▀▄░█▀▀░█▀▄
#░█▀▄░█░█░█░█░░█░░█░░░█░█░█▀█░█░█░█▀▀░█▀▄
#░▀▀░░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀
  
  #hardware.bluetooth.enable = true; # enables support for Bluetooth
  #hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
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
    kernel.sysctl = {
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
    };

    kernelPackages = pkgs.linuxPackages_zen;

    loader.timeout = 0;
    loader.systemd-boot.consoleMode = "auto";
    
    # Add a midi bridge for BLE MIDI devices
    kernelModules = [ "snd-virmidi" ];
    extraModprobeConfig = ''
      options snd-virmidi midi_devs=1
    '';
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
  networking.firewall.enable = false;


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
    extraGroups = [ "networkmanager" "wheel" "libvrtd" "kvm" "qemu-libvirtd" "cdrom" "uucp" "docker" ];
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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [ "*" ];
      };
      niri = {
        default = [
          "gtk"
          "gnome"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
  };



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
    jack.enable = true;
  };

  hardware.kawaiCA49 = {
    enable = true;
    user = "nicole";
  };

  # ISO mounting utils #
  programs.cdemu.enable = true;
  
  # KDE Connect
  programs.kdeconnect.enable = true;

  # OLLAMA #
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    package = pkgs-unstable.ollama;
    environmentVariables = {
      CUDA_VISIBLE_DEVICES = "0";
      NVIDIA_VISIBLE_DEVICES = "all";
      LD_LIBRARY_PATH = "${pkgs-unstable.cudaPackages.cudatoolkit}/lib:${pkgs-unstable.cudaPackages.cudatoolkit}/lib64";
    };
  };

  # STEAM #
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable =  true;
 
  # DEFAULTS #
  environment = {
    sessionVariables = {
      EDITOR = "zed";
      BROWSER = "app.zen_browser.zen.desktop";
      TERMINAL = "kitty";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      NIXOS_OZONE_WL = "1";
    };
    #etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".source = ./50-limit-free-buffer-pool.json;
  };

  # Fonts with emojis uwu #
  fonts.packages = with pkgs; [ 
  nerd-fonts.jetbrains-mono 
  material-symbols
  inter
  fira-code
  ];

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

