{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "button.lid_init_state=open" ];
  boot.extraModulePackages = [ ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/04a5bafa-77e5-492a-8479-40f3850e627b";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C06F-1A78";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/04a5bafa-77e5-492a-8479-40f3850e627b";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/04a5bafa-77e5-492a-8479-40f3850e627b";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/122d9a22-2fb2-425d-b3b8-2f85ce272c51"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0f1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
