{ pkgs ? import <nixpkgs> {}, compileHS ? false }:
let
  elmi-to-json =
    let set = import ./elmi-to-json.nix { inherit pkgs; };
    in if compileHS then set.fromSource else set.blob;

  elmNodePackages =
    import ./composition.nix {
      inherit pkgs;
      inherit (pkgs) nodejs;
      inherit (pkgs.stdenv.hostPlatform) system;
    };

  patchBinwrap =
    import ./patch-binwrap.nix {
      inherit elmi-to-json;
      inherit(pkgs) writeScriptBin stdenv;
    };
in
with elmNodePackages;
{
  elm-test = patchBinwrap elm-test;
  elm-verify-examples = patchBinwrap elm-verify-examples;
  inherit elm-analyse elm-doc-preview;
}
