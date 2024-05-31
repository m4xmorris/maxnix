{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.opengl.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
  };
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.xrandrHeads = [
    { output = "DP-2"; primary = true; }
  ];

  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.exportConfiguration = true;
  services.xserver.screenSection = ''
    Option "metamodes" "DP-2: 2560x1440_75 +2560+0, DP-0: 2560x1440_75 +0+0"
  '';

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a9fbc392-4db5-4729-b4b1-efef0c0a0cc2";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/a9fbc392-4db5-4729-b4b1-efef0c0a0cc2";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/a9fbc392-4db5-4729-b4b1-efef0c0a0cc2";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/37A4-8181";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/fe7a32f3-7b94-453d-bacf-f3cd73092b45"; }
    ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.systemPackages = with pkgs; [
    solaar
  ];

}
