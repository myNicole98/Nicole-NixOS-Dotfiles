{
  lib,
  fetchurl,
  buildFHSEnv,
  writeShellScript,
  dpkg,
  stdenv,
  gtk3,
  glib,
  libGL,
  mesa,
  cairo,
  pango,
  gdk-pixbuf,
  atk,
  dbus,
  libx11,
  libxext,
  libxrender,
  libxtst,
  libxi,
  libxfixes,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxrandr,
  libxscrnsaver,
  alsa-lib,
  udev,
  nspr,
  nss,
  expat,
  cups,
  at-spi2-atk,
  at-spi2-core,
  libdrm,
  wayland,
  libxkbcommon,
  webkitgtk_4_1,
  openssl,
  zlib,
  libpng,
  libjpeg,
  freetype,
  fontconfig,
  sqlite,
  curl,
  vulkan-loader,
  libsoup_3,
  gst_all_1,
}:

let
  unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "anycubic-slicer-next-unwrapped";
    version = "1.3.7171";

    src = fetchurl {
      url = "https://cdn-universe-slicer.anycubic.com/prod/dists/noble/main/binary-amd64/AnycubicSlicerNext-${finalAttrs.version}_20250928_162543-Ubuntu_24_04_2_LTS.deb";
      hash = "sha256-oB/oY8xO/o+UOXR4K/yy0dAIrjB3ztBl9j24k9ceH5I=";
    };

    nativeBuildInputs = [ dpkg ];

    # The default unpack phase doesn't handle .deb files;
    # unpack manually with dpkg-deb.
    unpackPhase = ''
      dpkg-deb -x $src unpacked
    '';

    # Prebuilt binary; there is nothing to compile.
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 unpacked/usr/bin/AnycubicSlicerNext \
        $out/bin/AnycubicSlicerNext

      mkdir -p $out/share
      cp -r unpacked/usr/share/AnycubicSlicerNext $out/share/AnycubicSlicerNext

      # Install bundled shared libraries so the FHS env can expose them
      # under /usr/lib where the binary's hardcoded RPATHs expect them.
      find unpacked -name '*.so' -o -name '*.so.*' | while read -r f; do
        install -Dm755 "$f" $out/lib/$(basename "$f")
      done

      iconFile=$(find unpacked -type f \( -name "*.png" -o -name "*.svg" \) -print -quit 2>/dev/null)
      if [ -n "$iconFile" ]; then
        mkdir -p $out/share/icons/hicolor/256x256/apps
        cp "$iconFile" $out/share/icons/hicolor/256x256/apps/anycubic-slicer-next.png
      fi

      runHook postInstall
    '';

    meta = {
      description = "G-code slicer for Anycubic 3D printers (unwrapped binary)";
      homepage = "https://wiki.anycubic.com/en/software-and-app/anycubic-slicer-next-linux";
      license = lib.licenses.agpl3Only;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      maintainers = with lib.maintainers; [ ];
    };
  });

  runtimeLibs = [
    gtk3
    glib
    libGL
    mesa
    cairo
    pango
    gdk-pixbuf
    atk
    dbus
    libx11
    libxext
    libxrender
    libxtst
    libxi
    libxfixes
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxrandr
    libxscrnsaver
    alsa-lib
    udev
    nspr
    nss
    expat
    cups
    at-spi2-atk
    at-spi2-core
    libdrm
    wayland
    libxkbcommon
    webkitgtk_4_1
    openssl
    zlib
    libpng
    libjpeg
    freetype
    fontconfig
    sqlite
    curl
    vulkan-loader
    libsoup_3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  launcherScript = writeShellScript "anycubic-slicer-next-launcher" ''
    if [ -d /run/opengl-driver/lib ]; then
      export LD_LIBRARY_PATH=/run/opengl-driver/lib:$LD_LIBRARY_PATH
    fi

    # NVIDIA + Wayland causes a silent crash on launch due to GBM/EGL issues.
    # Fall back to XWayland by forcing X11 backends.
    if [ "''${XDG_SESSION_TYPE:-}" = "wayland" ] \
        && [ -f /run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json ]; then
      unset WAYLAND_DISPLAY
      export GDK_BACKEND=x11
      export QT_QPA_PLATFORM=xcb
    fi

    exec ${unwrapped}/bin/AnycubicSlicerNext "$@"
  '';

in
buildFHSEnv {
  name = "anycubic-slicer-next";

  # buildFHSEnv provides a standard FHS filesystem layout at runtime,
  # which this Ubuntu-built binary requires to resolve its hardcoded
  # library and resource paths.
  targetPkgs = _: runtimeLibs ++ [ unwrapped ];

  extraBwrapArgs = [
    "--chdir" "/tmp"
    "--ro-bind"
    "${unwrapped}/share/AnycubicSlicerNext"
    "/usr/share/AnycubicSlicerNext"
  ];

  runScript = "${launcherScript}";

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps

    if [ -f ${unwrapped}/share/icons/hicolor/256x256/apps/anycubic-slicer-next.png ]; then
      cp ${unwrapped}/share/icons/hicolor/256x256/apps/anycubic-slicer-next.png \
        $out/share/icons/hicolor/256x256/apps/
    fi

    cat > $out/share/applications/anycubic-slicer-next.desktop << EOF
    [Desktop Entry]
    Name=Anycubic Slicer Next
    Comment=G-code slicer for Anycubic 3D printers
    Exec=$out/bin/anycubic-slicer-next
    Icon=anycubic-slicer-next
    Terminal=false
    Type=Application
    Categories=Graphics;3DGraphics;Engineering;
    StartupNotify=true
    EOF
  '';

  meta = {
    description = "G-code slicer for Anycubic 3D printers, based on OrcaSlicer";
    homepage = "https://wiki.anycubic.com/en/software-and-app/anycubic-slicer-next-linux";
    changelog = "https://wiki.anycubic.com/en/software-and-app/anycubic-slicer-next-linux";
    license = lib.licenses.agpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "anycubic-slicer-next";
    maintainers = with lib.maintainers; [ ];
  };
}
