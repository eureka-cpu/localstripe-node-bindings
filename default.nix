{ nixpkgs ? <nixpkgs> }:
let
  pkgs = import nixpkgs {
    overlays = [ (import ./overlay.nix) ];
  };
in
pkgs.localstripe
