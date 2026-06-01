{
  lib,
  requireFile,
  runCommand,
  stdenv,
  which,
  wineWow64Packages,
}:
let
  version = "5.38a";
in
stdenv.mkDerivation {
  pname = "keil-uvision";
  inherit version;

  installer = requireFile {
    name = "mdk538a.exe";
    url = "https://www.keil.com/demo/eval/arm.htm";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    which
    wineWow64Packages.stable
  ];

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild

    export WINEPREFIX="$PWD/.wine"
    export WINEDLLOVERRIDES="mscoree,mshtml="
    export WINEARCH="win32"

    wineboot --init
    ${wineWow64Packages.stable}/bin/wine "$installer" /quiet

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    target="$out/opt/keil-uvision"
    mkdir -p "$target"

    cp -r "$WINEPREFIX/drive_c/Keil_v5" "$target/"
    mkdir -p "$out/bin"

    cat > "$out/bin/keil-uvision" <<'WRAPPER'
    #!/bin/sh
    export WINEPREFIX="''${WINEPREFIX:-$HOME/.keil_prefix}"
    export WINEDLLOVERRIDES="mscoree,mshtml="
    if [ ! -f "$WINEPREFIX/drive_c/Keil_v5/UV4/UV4.exe" ]; then
      mkdir -p "$(dirname "$WINEPREFIX/drive_c/Keil_v5")"
      cp -r @out@/opt/keil-uvision/Keil_v5 "$WINEPREFIX/drive_c/Keil_v5"
    fi
    exec ${wineWow64Packages.stable}/bin/wine "C:\\Keil_v5\\UV4\\UV4.exe" "$@"
    WRAPPER

    substituteInPlace "$out/bin/keil-uvision" \
      --subst-var-by out "$out"

    chmod +x "$out/bin/keil-uvision"

    runHook postInstall
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "Keil MDK µVision 5 IDE for ARM embedded development";
    homepage = "https://www.keil.com/demo/eval/arm.htm";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "keil-uvision";
  };
}
