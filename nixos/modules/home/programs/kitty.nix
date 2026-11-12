{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 10000;
      cursor_shape = "block";
      cursor_blink_interval = 0;
      window_padding_width = 1;
      #cursor_trail = 3;
      resize_debounce_time = "0";
      placement_strategy = "top-left";
    };
    extraConfig = ''
      include themes/noctalia.conf
    '';
  };
}
