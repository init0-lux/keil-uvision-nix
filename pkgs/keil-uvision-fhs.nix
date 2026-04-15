{ buildFHSUserEnv
, callPackage
}:
let
  keil-uvision = callPackage ./keil-uvision.nix { };
in buildFHSUserEnv {
  name = "keil-uvision-fhs";
  targetPkgs = pkgs: [ keil-uvision ];
  runScript = "keil-uvision";
}
