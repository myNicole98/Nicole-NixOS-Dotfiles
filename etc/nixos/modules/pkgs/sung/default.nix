{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  python3,
  ffmpeg,
  nodejs,
  pulseaudio,
}:

let
  # Replaces the venv that scripts/install.sh builds from helper/requirements.txt.
  # nixpkgs supplies these versions, which may differ from the pins in that file.
  pythonEnv = python3.withPackages (ps: [
    ps.ytmusicapi
    ps.yt-dlp
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sung";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "yappologistic";
    repo = "Sung";
    rev = "2edcaff81ce96363c4f9de275944a2ce53770772";
    # Replace with the real hash: run the build once and copy the hash it reports.
    hash = "sha256-MCBI6J+DfP5cGg0pKk2ZNFe2gu7/QjNUPqUiTLBRq3w=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtwayland
  ];

  cmakeBuildType = "Release";

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DSUNG_DIAGNOSTICS=OFF"
  ];

  # The binary looks for its Python in SUNG_PYTHON and for the helper next to
  # its install prefix (lib/sung/catalog.py), so only the interpreter needs setting.
  # PATH covers the external tools the app runs: ffmpeg for thumbnails, node for
  # yt-dlp's JavaScript challenge solver, and pactl for output-device monitoring.
  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ffmpeg
      nodejs
      pulseaudio
    ])
    "--set"
    "SUNG_PYTHON"
    "${pythonEnv}/bin/python3"
  ];

  meta = {
    description = "A native Material 3 music player for Linux (YouTube Music, local audio, synchronized lyrics)";
    homepage = "https://github.com/yappologistic/Sung";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "sung";
  };
})
