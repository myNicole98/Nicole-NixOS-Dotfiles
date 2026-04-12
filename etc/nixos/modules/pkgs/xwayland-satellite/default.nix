{ lib
, fetchFromGitHub
, libxcb
, makeBinaryWrapper
, nix-update-script
, pkg-config
, rustPlatform
, xcb-util-cursor
, xwayland
, withSystemd ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "xwayland-satellite";
  version = "0.8.0-a879e5e0896a326adc79c474bf457b8b99011027";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = "a879e5e0896a326adc79c474bf457b8b99011027";
    hash = "sha256-wToKwH7IgWdGLMSIWksEDs4eumR6UbbsuPQ42r0oTXQ=";
  };

  cargoHash = "sha256-jbEihJYcOwFeDiMYlOtaS8GlunvSze80iWahDj1qDrs=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxcb
    xcb-util-cursor
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional withSystemd "systemd";

  doCheck = false;

  postInstall = lib.optionalString withSystemd ''
    install -Dm0644 resources/xwayland-satellite.service -t $out/lib/systemd/user
  '';

  postFixup = ''
    wrapProgram $out/bin/xwayland-satellite \
      --prefix PATH : "${lib.makeBinPath [ xwayland ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "xwayland-satellite with XSETTINGS crash fix";
    longDescription = ''
      Grants rootless Xwayland integration to any Wayland compositor implementing xdg_wm_base.
      This version includes a fix for XSETTINGS-related crashes with Electron applications.
    '';
    homepage = "https://github.com/Supreeeme/xwayland-satellite";
    license = lib.licenses.mpl20;
    mainProgram = "xwayland-satellite";
    platforms = lib.platforms.linux;
  };
}
