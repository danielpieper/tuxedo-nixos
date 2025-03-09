{
  description = "Tuxedo Control Center for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-22-11.url = "github:NixOS/nixpkgs/nixos-22.11";

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-22-11,
      flake-compat,
    }:
    let
      system = "x86_64-linux";
      tuxedo-control-center =
        (import nixpkgs-22-11 {
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
            ];
          };
        }).pkgs.callPackage
          ./pkgs/tuxedo-control-center
          {
            electron_34 = (import nixpkgs { inherit system; }).electron_34;
          };
    in
    {
      packages.x86_64-linux.default = tuxedo-control-center;

      overlay = (
        final: prev: {
          inherit tuxedo-control-center;
        }
      );

      nixosModules.default = import ./modules/tuxedo-control-center.nix;
    };
}
