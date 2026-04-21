{
  appimageTools,
  fetchurl,
  nodejs,
  nodePackages,
  uv,
  python3,
  makeWrapper,
}: let
  pname = "msty-studio";
  version = "2.6.4";
  src = fetchurl {
    url = "https://next-assets.msty.studio/app/releases/2.6.4/linux/MstyStudio_x86_64.AppImage";
    sha256 = "sha256-tCtQdmsC2s/IXvoLcHUTy1gEt78K4nIJ6hQCbzD+mjU=";
  };
  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;
    nativeBuildInputs = [makeWrapper];
    extraPkgs = pkgs: [
      nodejs
      nodePackages.npm
      uv
      python3
    ];
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/MstyStudio.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/MstyStudio.desktop \
              --replace 'Exec=AppRun' 'Exec=${pname}'
      install -m 444 -D ${appimageContents}/MstyStudio.png \
              $out/share/icons/hicolor/256x256/apps/MstyStudio.png
              wrapProgram $out/bin/${pname} \
                      --prefix PATH : ${nodejs}/bin:${nodePackages.npm}/bin:${uv}/bin:${python3}/bin
    '';
  }
