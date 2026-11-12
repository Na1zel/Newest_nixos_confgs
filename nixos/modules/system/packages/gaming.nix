{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # Gaming
    mangohud mesa-demos
    vulkan-tools prismlauncher #usty-path-of-building
    steam-run steamcmd
    #heroic faugus-launcher goverlay # поставить goverlay когда починят

    #nzportable # убрать когда выйдет уже 2.0.0 стабильный релиз
    #angband # убрать если хочешь поставить
    #supertux # убрать если хочешь поставить
    #supertuxkart # убрать когда выйдет 2.0 evoltuin обновление

  ];
}
