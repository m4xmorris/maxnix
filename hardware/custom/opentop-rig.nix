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
    opengl.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    pulseaudio.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    wireless.enable = false;
  };

  sound.enable = true;

  services = {
    blueman.enable = true;
    xserver = {
      xrandrHeads = [
        { output = "DP-2"; primary = true; }
      ];

      videoDrivers = ["nvidia"];
      exportConfiguration = true;
      screenSection = ''
        Option "metamodes" "DP-2: 2560x1440_75 +2560+0, DP-0: 2560x1440_75 +0+0"
      '';
    };
  };

  fileSystems = {
    "/" =
      { device = "/dev/disk/by-uuid/a9fbc392-4db5-4729-b4b1-efef0c0a0cc2";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

    "/home" =
      { device = "/dev/disk/by-uuid/a9fbc392-4db5-4729-b4b1-efef0c0a0cc2";
        fsType = "btrfs";
        options = [ "subvol=@home" ];
      };

    "/nix" =
      { device = "/dev/disk/by-uuid/a9fbc392-4db5-4729-b4b1-efef0c0a0cc2";
        fsType = "btrfs";
        options = [ "subvol=@nix" ];
      };

    "/boot" =
      { device = "/dev/disk/by-uuid/37A4-8181";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/fe7a32f3-7b94-453d-bacf-f3cd73092b45"; } ];

  environment.systemPackages = with pkgs; [
    solaar
  ];

}
