{ config, pkgs, lib, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 0;

    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl."kernel.sysrq" = 1;

    tmp.useTmpfs = true;
  };
}
