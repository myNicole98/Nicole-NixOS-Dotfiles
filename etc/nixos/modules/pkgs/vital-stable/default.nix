{ lib, stdenv, fetchzip, fetchurl, autoPatchelfHook, makeBinaryWrapper
, alsa-lib, libjack2, curl, xorg, libGL, freetype, zenity, makeDesktopItem
, copyDesktopItems, libsecret, glib, gnutls, dpkg, nettle, libidn2, nghttp2
, libpsl, zlib, zstd, brotli, openldap, libkrb5, rtmpdump, libssh2, libssh }:
let
  icon = fetchurl {
    url = "https://vital.audio/images/apple_touch_icon.png";
    hash = "sha256-NZ/AQ2gjBXUPUj3ITbowD7HuxRmEDuATOWidLqLNrww=";
  };
  
  # Fetch libcurl-gnutls from Ubuntu Noble package
  libcurlGnutls = stdenv.mkDerivation {
    name = "libcurl-gnutls";
    
    src = fetchurl {
      url = "http://security.ubuntu.com/ubuntu/pool/main/c/curl/libcurl3t64-gnutls_8.5.0-2ubuntu10.6_amd64.deb";
      sha256 = "38167d8ff4c180eceb0afb1a9bd3f343b07f87308894dd86866c5b1a3c14eebd";
    };
    
    nativeBuildInputs = [ dpkg autoPatchelfHook ];
    buildInputs = [ gnutls nettle libidn2 nghttp2 libpsl zlib zstd brotli 
                    openldap libkrb5 rtmpdump libssh2 libssh stdenv.cc.cc.lib ];
    
    unpackPhase = ''
      dpkg-deb -x $src .
    '';
    
    installPhase = ''
      mkdir -p $out/lib
      cp -P usr/lib/x86_64-linux-gnu/libcurl-gnutls.so* $out/lib/
    '';
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "vital";
  version = "1.0.7";

  src = fetchzip {
    url =
      "https://builds.vital.audio/VitalAudio/vital/${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}/VitalInstaller.zip";
    hash = "sha256-qnkyoFRnA78B/5q1oBjOBqqOXG9C3XvICjKspEa+Ids=";
  };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "vital";
      desktopName = "Vital";
      comment = "Spectral warping wavetable synth";
      icon = "Vital";
      exec = "Vital";
      categories = [ "Audio" "AudioVideo" ];
    })
  ];

  nativeBuildInputs =
    [ autoPatchelfHook makeBinaryWrapper copyDesktopItems ];

  buildInputs = [
    alsa-lib
    (lib.getLib stdenv.cc.cc)
    libGL
    xorg.libSM
    xorg.libICE
    xorg.libX11
    freetype
    libjack2
    libsecret
    glib
    libcurlGnutls
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 ${icon} $out/share/pixmaps/Vital.png

    # fetchzip strips the top-level directory, so files are directly accessible
    # Install standalone binary
    install -Dm755 vital $out/bin/Vital

    # Install VST2
    mkdir -p $out/lib/vst
    cp Vital.so $out/lib/vst/Vital.so

    # Install VST3
    mkdir -p $out/lib/vst3
    cp -r Vital.vst3 $out/lib/vst3/

    # Install LV2
    mkdir -p $out/lib/lv2
    cp -r Vital.lv2 $out/lib/lv2/

    wrapProgram $out/bin/Vital \
      --prefix LD_LIBRARY_PATH : "${libcurlGnutls}/lib:${
        lib.makeLibraryPath [ libjack2 ]
      }" \
      --prefix PATH : "${lib.makeBinPath [ zenity ]}"

    runHook postInstall
  '';

  meta = {
    description = "Spectral warping wavetable synth";
    homepage = "https://vital.audio/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree; # https://vital.audio/eula/
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ PowerUser64 l1npengtul ];
    mainProgram = "Vital";
  };
})
