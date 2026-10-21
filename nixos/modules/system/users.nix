{ config, pkgs, ... }:

{
  users.users.naizel = {
    isNormalUser = true;
    description = "naizel";

    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "gamemode"
    ];
  };
}
