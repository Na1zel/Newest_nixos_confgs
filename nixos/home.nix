{ config, pkgs, pkgs-stable, inputs, lib, ... }:

{
  imports = [ ./modules/home ];

  home.stateVersion = "26.05"; # меняй на свою когда будешь ставить первый раз
}
