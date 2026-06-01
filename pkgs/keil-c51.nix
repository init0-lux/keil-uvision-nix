{
  lib,
  requireFile,
  stdenv,
  which,
  wineWow64Packages,
}:
let
  version = "9.61";
in
stdenv.mkDerivation {
  pname = "keil-c51";
  inherit version;

  installer = requireFile {
    name = "c51v961.exe";
    url = "https://www.keil.com/demo/eval/c51.htm";
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

    target="$out/opt/keil-c51"
    mkdir -p "$target"

    cp -r "$WINEPREFIX/drive_c/Keil" "$target/"
    mkdir -p "$out/bin"

    cat > "$out/bin/keil-c51" <<'WRAPPER'
    #!/bin/sh
    export WINEPREFIX="''${WINEPREFIX:-$HOME/.keil_prefix}"
    export WINEDLLOVERRIDES="mscoree,mshtml="
    if [ ! -d "$WINEPREFIX/drive_c/Keil" ]; then
      mkdir -p "$(dirname "$WINEPREFIX/drive_c/Keil")"
      cp -r @out@/opt/keil-c51/Keil "$WINEPREFIX/drive_c/Keil"
    fi
    exec ${wineWow64Packages.stable}/bin/wine "$installer" "$@"
    WRAPPER

    substituteInPlace "$out/bin/keil-c51" \
      --subst-var-by out "$out"

    chmod +x "$out/bin/keil-c51"

    runHook postInstall
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "Keil C51 compiler for 8051 embedded development";
    homepage = "https://www.keil.com/demo/eval/c51.htm";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "keil-c51";
  };
}
