{ ... }:

{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    checkConfig = true;

    settings = {
    shell.polkit_agent = true;
      theme = {
        source = "wallpaper";
        templates = {
          enable_builtin_templates = true;
          builtin_ids = [ "hyprland" "kitty" ];
        };
      };
      brightness = {
        enable_ddcutil = true;
      };
    };
  };
}
