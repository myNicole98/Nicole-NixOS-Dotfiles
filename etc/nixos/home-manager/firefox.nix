{ config
, pkgs
, lib
, ...
}:
let
  darkreaderHost = pkgs.runCommand "darkreader-host" {} ''
    mkdir -p $out/bin
    ${pkgs.gcc}/bin/gcc -O2 -o $out/bin/darkreader ${./files/coloreader-native.c}
  '';
  darkreaderManifest = {
    name = "darkreader";
    description = "custom darkreader native host for syncing with pywal";
    path = "${darkreaderHost}/bin/darkreader";
    type = "stdio";
  };
in
{
  config.home.file = {
    ".mozilla/native-messaging-hosts/darkreader.json".text = builtins.toJSON
      (darkreaderManifest // { allowed_extensions = [ "darkreader@alexhulbert.com" ]; });
  };

  config.home.activation.firefoxWalTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ln -sf "${config.xdg.cacheHome}/wal/userContent.css" \
      "${config.home.homeDirectory}/.mozilla/firefox/default/chrome/userContent.css"
  '';
  config.programs.firefox = {
  enable = false;
  profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;
    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
    userChrome = ''
      @import url('userContent.css');
    '';
  };
};

}
