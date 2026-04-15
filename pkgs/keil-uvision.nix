{ aria2
, wineWow64Packages
, writeShellScriptBin
}:
let
  url = "https://www.keil.com/fid/z997v087b2y7w4m2o1w2w8k897r5v0v4v822y1/files/eval/mdk538a.exe";
in writeShellScriptBin "keil-uvision" ''
  export WINEPREFIX="''${WINEPREFIX:-$HOME/.keil_prefix}"
  export WINEDLLOVERRIDES="mscoree,mshtml="

  if [ ! -f "$WINEPREFIX/drive_c/Keil_v5/UV4/UV4.exe" ]; then
    LOCAL_INSTALLER="$(pwd)/mdk538a.exe"
    TMP_INSTALLER="/tmp/mdk538a.exe"
    
    if [ -f "$LOCAL_INSTALLER" ]; then
      INSTALLER="$LOCAL_INSTALLER"
    elif [ -f "$TMP_INSTALLER" ]; then
      INSTALLER="$TMP_INSTALLER"
    else
      ${aria2}/bin/aria2c -x 16 -s 16 -k 1M -o mdk538a.exe -d /tmp "${url}"
      INSTALLER="$TMP_INSTALLER"
    fi
    
    ${wineWow64Packages.stable}/bin/wine "$INSTALLER"
  else
    ${wineWow64Packages.stable}/bin/wine "C:\\Keil_v5\\UV4\\UV4.exe" "$@"
  fi
''


