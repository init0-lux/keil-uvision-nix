{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "keil-uvision-smoke-test";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out
    echo "true" > $out/success
  '';
}
