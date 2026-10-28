{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "pi-gui";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/minghinmatthewlam/pi-gui/releases/download/v${version}/pi-gui-${version}-x86_64.AppImage";
    hash = "sha256-WByWXZajwvDbPx6I6Ro8PRHxNT3TFYpXy+XLmJ1TdoE=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [
    pkgs.git
    pkgs.nodejs
  ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/pi-gui.desktop $out/share/applications/pi-gui.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/pi-gui.png \
      $out/share/icons/hicolor/512x512/apps/pi-gui.png
    substituteInPlace $out/share/applications/pi-gui.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=pi-gui'
  '';

  meta = {
    description = "Desktop app for the pi coding agent";
    homepage = "https://www.pi-gui.com/";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "pi-gui";
  };
}
