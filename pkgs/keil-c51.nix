{ aria2
, wineWow64Packages
, writeShellScriptBin
}:
let
  url = "https://www.keil.com/fid/yzg04kwtdy9j1wwcox91rgd4umlvhujmp9yxd1/files/eval/c51v961.exe";
in writeShellScriptBin "keil-c51" ''
  export WINEPREFIX="''${WINEPREFIX:-$HOME/.keil_prefix}"
  export WINEDLLOVERRIDES="mscoree,mshtml="

  LOCAL_INSTALLER="$(pwd)/c51v961.exe"
  TMP_INSTALLER="/tmp/c51v961.exe"
  
  if [ -f "$LOCAL_INSTALLER" ]; then
    INSTALLER="$LOCAL_INSTALLER"
  elif [ -f "$TMP_INSTALLER" ]; then
    INSTALLER="$TMP_INSTALLER"
  else
    ${aria2}/bin/aria2c -x 16 -s 16 -k 1M -o c51v961.exe -d /tmp "${url}"
    INSTALLER="$TMP_INSTALLER"
  fi
  
  ${wineWow64Packages.stable}/bin/wine "$INSTALLER"
''
