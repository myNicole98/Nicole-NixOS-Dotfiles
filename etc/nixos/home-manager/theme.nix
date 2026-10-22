 { config, pkgs, lib, ... }:
{
  home.pointerCursor = {
    enable = true;
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 24;
    gtk.enable = true;
  };
  
  home.activation.papirusMutable = lib.hm.dag.entryAfter ["writeBoundary"] ''
  if [ ! -d "$HOME/.local/share/icons/Papirus" ]; then
    cp -r ${pkgs.papirus-icon-theme}/share/icons/Papirus \
      "$HOME/.local/share/icons/Papirus"
    chmod -R u+w "$HOME/.local/share/icons/Papirus"
  fi
  '';

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus";
  };
  gtk.cursorTheme = {
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 24;
  };
  home.packages = [ pkgs.papirus-icon-theme pkgs.papirus-folders pkgs.gawk pkgs.gtk3 ];
} 
