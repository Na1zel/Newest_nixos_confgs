{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # Office
    libreoffice

    # Image / creative / 3D
    krita gimp upscaler #darktable
    imv

    # Music
    cmus

    # Video editing
    #kdePackages.kdenlive

    # Communication
    ayugram-desktop vesktop

    # Text-editor
    xed-editor

    # Torrents
    transmission_4-gtk

    # KDE utilities
    kdePackages.breeze-icons
    pcmanfm xarchiver ffmpegthumbnailer
  ];
}
