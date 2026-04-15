{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      default = pkgs.callPackage ./pkgs/keil-uvision.nix { };
      keil-uvision = pkgs.callPackage ./pkgs/keil-uvision.nix { };
      keil-c51 = pkgs.callPackage ./pkgs/keil-c51.nix { };
      keil-uvision-fhs = pkgs.callPackage ./pkgs/keil-uvision-fhs.nix { };
    };
  };
}
