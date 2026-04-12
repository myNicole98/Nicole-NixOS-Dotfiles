{ pkgs ? import <nixpkgs> {} }:
let
  lutrisUnwrapped = pkgs.lutris-unwrapped;

  lutrisPythonPatched = pkgs.runCommand "lutris-python-patched" {} ''
    cp -r ${lutrisUnwrapped}/lib $out
    chmod -R +w $out
    mkdir -p $out/lib/${pkgs.python3.libPrefix}/site-packages/share
    ln -s ${lutrisUnwrapped}/share/lutris $out/lib/${pkgs.python3.libPrefix}/site-packages/share/lutris
  '';

  pythonEnv = pkgs.python3.withPackages (ps: [
    ps.pygobject3
    ps.dbus-python
    ps.pyyaml
  ]);

  pythonPath = pkgs.lib.concatStringsSep ":" [
    "${lutrisPythonPatched}/lib/${pkgs.python3.libPrefix}/site-packages"
    "${pythonEnv}/${pythonEnv.sitePackages}"
  ];

  extraPkgsList = with pkgs; [
    lutrisUnwrapped
    gobject-introspection
    glib
    gtk3
    pango
    harfbuzz
    gdk-pixbuf
    at-spi2-core
    pulseaudio
    bluez
  ];

  girepositoryPath = pkgs.lib.makeSearchPath "lib/girepository-1.0" extraPkgsList;

  pythonWrapper = pkgs.writeShellScriptBin "python3" ''
    export PYTHONPATH="${pythonPath}''${PYTHONPATH:+:$PYTHONPATH}"
    export GI_TYPELIB_PATH="${girepositoryPath}''${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}"
    exec ${pkgs.python3}/bin/python3 "$@"
  '';

in pkgs.appimageTools.wrapType2 {
  pname = "lutris-gamepad-ui";
  version = "0.1.32";

  src = pkgs.fetchurl {
    url = "https://github.com/andrew-ld/lutris-gamepad-ui/releases/download/v0.1.32/lutris-gamepad-ui-x64.AppImage";
    hash = "sha256-68j04sSnDtoNZfCGRmWpq0xcy8F1xBEDPqFIuTwYcEo=";
  };

  extraPkgs = _: extraPkgsList ++ [ pythonWrapper ];

  extraInstallCommands = ''
    fhsrootfs=$(grep -o '/nix/store/[^-]*-[^/]*-fhsenv-rootfs' $out/bin/lutris-gamepad-ui | head -1)
    typelib_path="${girepositoryPath}:$fhsrootfs/usr/lib/girepository-1.0:$fhsrootfs/usr/lib64/girepository-1.0"
    wrapper_bin="${pythonWrapper}/bin"

    # Write a preamble script then reconstruct the wrapper
    head -n -1 $out/bin/lutris-gamepad-ui > /tmp/wrapper_new.sh
    echo "export PATH=\"$wrapper_bin:\$PATH\"" >> /tmp/wrapper_new.sh
    echo "export GI_TYPELIB_PATH=\"$typelib_path\"" >> /tmp/wrapper_new.sh
    tail -n 1 $out/bin/lutris-gamepad-ui >> /tmp/wrapper_new.sh
    chmod +x /tmp/wrapper_new.sh
    cp /tmp/wrapper_new.sh $out/bin/lutris-gamepad-ui
  '';
}
