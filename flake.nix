{
  description = "Tuxedo Control Center for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-compat,
    }:
    let
      system = "x86_64-linux";
      tcc-pkgs =
        (import nixpkgs {
          currentSystem = system;
          localSystem = system;
          overlays = [
            (final: prev: {
              nodejs = prev.pkgs.nodejs-14_x;
            })
          ];
          config = {
            allowInsecure = true;
            permittedInsecurePackages = [
              "nodejs-14.21.3"
              "electron-13.6.9"
              "openssl-1.1.1w"
            ];
          };
        }).pkgs;
      tuxedo-control-center = tcc-pkgs.callPackage ./pkgs/tuxedo-control-center {
        electron = tcc-pkgs.electron_13;
      };
    in
    {
      packages.x86_64-linux.default = tuxedo-control-center;

      overlays.default = (
        final: prev: {
          inherit tuxedo-control-center;
        }
      );

      nixosModules.default = import ./modules/tuxedo-control-center.nix;
    };
}
