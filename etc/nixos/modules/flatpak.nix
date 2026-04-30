{ config, ... }:
{
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
    "org.pitivi.Pitivi"
    "app.zen_browser.zen"
    "org.blender.Blender"
    "org.onlyoffice.desktopeditors"
    "com.rustdesk.RustDesk"
    "org.gimp.GIMP"
    "com.anydesk.Anydesk"
    "com.github.iwalton3.jellyfin-media-player"
  ];

}
