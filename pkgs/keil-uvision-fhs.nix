{
  buildFHSEnv,
  callPackage,
  lib,
}:
let
  keil-uvision = callPackage ./keil-uvision.nix { };
in
buildFHSEnv {
  name = "keil-uvision-fhs";
  targetPkgs = pkgs: [ keil-uvision ];
  runScript = "keil-uvision";

  meta = with lib; {
    description = "Keil MDK µVision 5 IDE in FHS-compatible environment";
    homepage = "https://www.keil.com/demo/eval/arm.htm";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "keil-uvision-fhs";
  };
}
