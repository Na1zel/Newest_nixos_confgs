{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # Desktop utilities
    #inotify-tools libnotify cliphist trash-cli app2unit
    brightnessctl

    # Wayland screenshot / clipboard / input
    #grim slurp wev pamixer
    wl-clipboard kitty

    # GTK / Qt theming
    adwaita-icon-theme
  ];

  environment.variables.EDITOR = "nvim"; # заменил nano default editor на vim default editor echo $EDITOR
}
