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
  version = "2.4.1";
  src = fetchurl {
    url = "https://next-assets.msty.studio/app/latest/linux/MstyStudio_x86_64.AppImage";
    sha256 = "sha256-YsXa4W0so5lQs6uex14QIoVg21cN7Bi0fWJMhChSDnA=";
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
