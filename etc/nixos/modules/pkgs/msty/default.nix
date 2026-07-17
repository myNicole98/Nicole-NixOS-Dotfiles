{
  appimageTools,
  fetchurl,
  nodejs,
  uv,
  python3,
  makeWrapper,
}: let
  pname = "msty-studio";
  version = "2.6.4";
  src = fetchurl {
    url = "https://next-assets.msty.studio/app/releases/2.6.4/linux/MstyStudio_x86_64.AppImage";
    sha256 = "sha256-cY4PL2l4+leDC/30VkmCL4KoVSC1slgqY0KGfsjUuhE=";
  };
  appimageContents = appimageTools.extractType2 {inherit pname version src;};
  
  npm = nodejs; 
in
  appimageTools.wrapType2 {
    inherit pname version src;
    nativeBuildInputs = [makeWrapper];
    extraPkgs = pkgs: [
      nodejs
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
                      --prefix PATH : ${nodejs}/bin:${uv}/bin:${python3}/bin
    '';
  }
