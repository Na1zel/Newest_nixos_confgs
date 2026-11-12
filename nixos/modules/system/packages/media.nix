{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # Playback
    mpv playerctl cava

    # Download / convert
    yt-dlp ffmpeg imagemagick

  ];
}
