{ tccOverlay }:

{
  imports = [
    ./tuxedo-control-center.nix
  ];

  nixpkgs.overlays = [ tccOverlay ];
}
