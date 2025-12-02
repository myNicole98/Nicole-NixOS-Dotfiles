#░█░█░▀█▀░█▀▄░▀█▀░█░█░█▀█░█░░░▀█▀░▀▀█░█▀█░▀█▀░▀█▀░█▀█░█▀█
#░▀▄▀░░█░░█▀▄░░█░░█░█░█▀█░█░░░░█░░▄▀░░█▀█░░█░░░█░░█░█░█░█
#░░▀░░▀▀▀░▀░▀░░▀░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀

{ config, pkgs, lib, ... }:

let
  # VFIO ids for passthrough
  vfioIds = [ "1002:13c0" "1002:1640" ];

  # Username
  user = "nicole";

in

{

  boot = {

    # Enable IOMMU
    kernelParams = lib.mkAfter [
      "amd_iommu=on" # Change to intel_iommu=on if you're using an Intel CPU
      "iommu=pt"
      "vfio-pci.ids=${builtins.concatStringsSep "," vfioIds}"
    ];

    # Add the required VFIO kernel modules
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];
    kernelModules = [
      "kvm"
      "kvmfr"
    ];

    # Add the GPU video and audio to VFIO binding
    extraModprobeConfig = ''
      options vfio-pci ids=${builtins.concatStringsSep "," vfioIds}
      options vfio_iommu_type1 allow_unsafe_interrupts=1
      options kvmfr static_size_mb=128
    '';
 
    # Enable the KVMFR kernel package
    extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
  };

  # Enable Virt-Manager
  programs.virt-manager.enable = true;
  
  # Add user to the "libvirtd" group for permission to manage VMs
  users.groups.libvirtd.members = ["${user}"];
  
  # Add a udev rule to set permissions for KVMFR (Kernel Frame Relay) device
  services.udev.extraRules = ''
    KERNEL=="kvmfr*", MODE="0660", GROUP="kvm"
  '';
  
  # Enable the libvirtd (virtualization) service
  virtualisation.libvirtd = {
    enable = true;
    # Configure QEMU
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  
  # Add additional QEMU configuration to explicitly define device ACLs
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm",
        "/dev/kvmfr0"
    ]
  '';
  
  # Define systemd temporary file rules to create a shared memory file for Looking Glass
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 ${user} qemu-libvirtd -"
    "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
  ];
  
  # Packages
  environment.systemPackages = lib.mkAfter (with pkgs; [
    spice spice-gtk
    spice-protocol
    #win-virtio # 25.05
    virtio-win # 25.11
    win-spice
    looking-glass-client
    linuxKernel.packages.linux_zen.kvmfr
    qemu
    (writeShellScriptBin "qemu-system-x86_64-uefi" ''
        qemu-system-x86_64 \
          -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
          "$@"
      '')
  ]);
}
