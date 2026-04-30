{ config, pkgs, pkgs-unstable, lib, inputs, ... }:


#░█░█░█▀▀░█▀▀░█▀▄░░░█░█░█▀█░█▀▄░▀█▀░█▀█░█▀▄░█░░░█▀▀░█▀▀
#░█░█░▀▀█░█▀▀░█▀▄░░░▀▄▀░█▀█░█▀▄░░█░░█▀█░█▀▄░█░░░█▀▀░▀▀█
#░▀▀▀░▀▀▀░▀▀▀░▀░▀░░░░▀░░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀▀▀░▀▀▀


let
  username = "nicole";
  userdesc = "Nicole";
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
      ./modules/flatpak.nix
      ./modules/bluetooth.nix
      ./modules/KawaiCA49.nix
      ./modules/logitech.nix
      ./modules/ollama.nix
      ./modules/sound.nix
      ./modules/xdg.nix
      ./modules/gdm.nix
      #./modules/gnome.nix
      #./modules/kde.nix
      ./modules/hyprland.nix
      ./modules/niri.nix
      ./cachix.nix
    ];

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/fc0150d8-4f57-4d95-abe9-4b979336b3ce";
    fsType = "ext4";
  };


#░█▀▄░█▀█░█▀█░▀█▀░█░░░█▀█░█▀█░█▀▄░█▀▀░█▀▄
#░█▀▄░█░█░█░█░░█░░█░░░█░█░█▀█░█░█░█▀▀░█▀▄
#░▀▀░░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀
  
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
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };
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

  users.users.${username} = {
    isNormalUser = true;
    description = userdesc;
    extraGroups = [ "networkmanager" "wheel" "libvrtd" "kvm" "qemu-libvirtd" "cdrom" "uucp" "docker" "audio"];
    packages = with pkgs; [];
  };

  services.cron = { 
    enable = true;
    systemCronJobs = [
      ""
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # DEFAULTS #
  environment = {
    sessionVariables = {
      EDITOR = "zed";
      BROWSER = "app.zen_browser.zen.desktop";
      TERMINAL = "kitty";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      NIXOS_OZONE_WL = "1";
    };
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
    enable = false;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
  dates = "02:00";
  randomizedDelaySec = "45min";
  };

  hardware.kawaiCA49 = {
    enable = true;
    user = username;
  };
}

