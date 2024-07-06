{ config, lib, pkgs, modulesPath, ... }:
{
  
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "kvm-intel" ];
      luks.devices."maxs-laptop".device = "/dev/disk/by-uuid/88450b78-2415-426a-ba04-a391c50e7bd0";
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    networkmanager.enable = true;
    wireless.enable = false;
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
      { device = "/dev/disk/by-uuid/2e1acf72-86dd-4f48-8ef2-7e1f59bf8eec";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

    "/boot" =
      { device = "/dev/disk/by-uuid/479F-0B57";
        fsType = "vfat";
        options = [ "fmask=007" "dmask=007" ];
      };

    "/nix" =
      { device = "/dev/disk/by-uuid/2e1acf72-86dd-4f48-8ef2-7e1f59bf8eec";
        fsType = "btrfs";
        options = [ "subvol=@nix" ];
      };

    "/home" =
      { device = "/dev/disk/by-uuid/2e1acf72-86dd-4f48-8ef2-7e1f59bf8eec";
        fsType = "btrfs";
        options = [ "subvol=@home" ];
      };

    "/swap" =
      { device = "/dev/disk/by-uuid/2e1acf72-86dd-4f48-8ef2-7e1f59bf8eec";
        fsType = "btrfs";
        options = [ "subvol=@swap" ];
      };
  };

  swapDevices =
    [ { device = "/swap/swapfile"; size = 4*1024; } ];

}

