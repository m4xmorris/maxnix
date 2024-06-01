{ config, lib, pkgs, modulesPath, ... }:
{
  
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot = {
    initrd = {
      availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
      kernelModules = [ "kvm-intel" ];
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    pulseaudio.enable = true;
  };

  services = {
    blueman.enable = true;
    logind.powerKey = "suspend";
  };

  sound.enable = true;
  
  fileSystems = {
    "/" =
      { device = "/dev/disk/by-uuid/04a5bafa-77e5-492a-8479-40f3850e627b";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

    "/boot" =
      { device = "/dev/disk/by-uuid/C06F-1A78";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };

    "/nix" =
      { device = "/dev/disk/by-uuid/04a5bafa-77e5-492a-8479-40f3850e627b";
        fsType = "btrfs";
        options = [ "subvol=@nix" ];
      };

    "/home" =
      { device = "/dev/disk/by-uuid/04a5bafa-77e5-492a-8479-40f3850e627b";
        fsType = "btrfs";
        options = [ "subvol=@home" ];
      };
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/122d9a22-2fb2-425d-b3b8-2f85ce272c51"; } ];

}

