{ config, pkgs, lib, ... }: 
{

  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/raspberry-pi/4"
    <nixpkgs/nixos/modules/installer/sd-card/sd-image.nix>
  ];

  nixpkgs = {
    localSystem.system = "aarch64-linux";
    overlays = [
      (final: super: {
        makeModulesClosure = x:
          super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    consoleLogLevel = lib.mkDefault 7;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernelParams = [ "console=ttyS0,115200n8" "console=ttyAMA0,115200n8" "console=tty0" ];
    initrd.availableKernelModules = [
    "vc4"
    "bcm2835_dma"
    "i2c_bcm2835"
    "sun4i_drm"
    "sun8i_drm_hdmi"
    "sun8i_mixer"
    ];
  };

  hardware.raspberry-pi."4".fkms-3d.enable = true;

  sdImage = {
    compressImage = true;
    populateFirmwareCommands = let
      configTxt = pkgs.writeText "config.txt" ''
        [pi3]
        kernel=u-boot-rpi3.bin
        [pi4]
        kernel=u-boot-rpi4.bin
        enable_gic=1
        armstub=armstub8-gic.bin
        disable_overscan=1
        [all]
        arm_64bit=1
        enable_uart=1
        avoid_warnings=1
      '';
    in ''
      (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)
      cp ${configTxt} firmware/config.txt
      cp ${pkgs.ubootRaspberryPi3_64bit}/u-boot.bin firmware/u-boot-rpi3.bin
      cp ${pkgs.ubootRaspberryPi4_64bit}/u-boot.bin firmware/u-boot-rpi4.bin
      cp ${pkgs.raspberrypi-armstubs}/armstub8-gic.bin firmware/armstub8-gic.bin
      cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-4-b.dtb firmware/
    '';
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };
  
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];
}
