{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # Desktop utilities
    #inotify-tools libnotify cliphist trash-cli app2unit
    brightnessctl kdePackages.filelight

    # Wayland screenshot / clipboard / input
    #grim slurp wev pamixer
    wl-clipboard

    # GTK / Qt theming
    adw-gtk3 adwaita-icon-theme
    kdePackages.oxygen
  ];

  environment.variables.EDITOR = "vim"; # заменил nano default editor на vim default editor echo $EDITOR
}
