{ pkgs ? import <nixpkgs> {}}:
let
    elmi-to-json = (import ./elmi-to-json.nix { inherit pkgs; }).blob;
in with pkgs;
{
  elm-test = import ./elm-test.nix {
    inherit elmi-to-json;
    inherit(pkgs) nodePackages writeScriptBin stdenv;
  };
}
