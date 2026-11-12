{ ... }:

{
  home.sessionVariables.TERMINAL = "kitty";
  
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # File manager
      "inode/directory" = "pcmanfm.desktop";

      # Text
      "text/x-nix" = "org.x.editor.desktop";
      "text/plain" = "org.x.editor.desktop";
      "application/x-zerosize" = "org.x.editor.desktop";
      "application/x-bak" = "org.x.editor.desktop";

      # Web
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";

      # Video
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/avi" = "mpv.desktop";
      "video/x-msvideo" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";

      # Audio
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";
      "audio/mp3" = "mpv.desktop";
      "audio/aac" = "mpv.desktop";
      "audio/x-aac" = "mpv.desktop";
      "audio/x-mpegurl" = "mpv.desktop";
      "audio/x-scpls" = "mpv.desktop";

      # Images
      "image/png" = "imv-dir.desktop";
      "image/jpeg" = "imv-dir.desktop";
      "image/gif" = "imv-dir.desktop";
      "image/webp" = "imv-dir.desktop";
      "image/svg+xml" = "imv-dir.desktop";
      "image/avif" = "imv-dir.desktop";
      "image/jxl" = "imv-dir.desktop";

      # Documents / Books
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/vnd.djvu" = "org.pwmt.zathura.desktop";
      "application/vnd.comicbook+zip" = "org.pwmt.zathura.desktop";
      "application/epub+zip" = "org.pwmt.zathura.desktop";

      # Torrents
      "application/x-bittorrent" = "transmission-gtk.desktop";
      "application/x-torrent" = "transmission-gtk.desktop";
      "x-scheme-handler/magnet" = "transmission-gtk.desktop";

      # Archives
      "application/zip" = "xarchiver.desktop";
      "application/x-tar" = "xarchiver.desktop";
      "application/x-compressed-tar" = "xarchiver.desktop";
      "application/x-bzip2-compressed-tar" = "xarchiver.desktop";
      "application/x-xz-compressed-tar" = "xarchiver.desktop";
      "application/x-7z-compressed" = "xarchiver.desktop";
      "application/x-rar" = "xarchiver.desktop";
      "application/x-rar-compressed" = "xarchiver.desktop";
      "application/x-zstd-compressed-tar" = "xarchiver.desktop";
    };
  };

  # Default terminal
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "kitty.desktop"
      ];
    };
  };
}
