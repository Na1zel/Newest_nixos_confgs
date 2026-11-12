{ pkgs, ... }:
{
  services.displayManager.ly.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };
}

# balooctl6 disable # вырубает его нахуй
# balooctl6 purge # чистить базу данных которую balooctl6 создал
# balooctl6 enable # включает его
# balooctl6 status # зачекать статус
# да и ваще надо бы генту ставить а то компиляция сама себя не накомпилирует и не оптимизирует


