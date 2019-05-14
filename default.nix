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
    import ./patch-bin-wrap.nix {
      inherit elmi-to-json;
      inherit(pkgs) writeScriptBin stdenv;
    };
in
with elmNodePackages;
{
  elm-test = elm-test.override patchBinwrap;
  elm-verify-examples = elm-verify-examples.override patchBinwrap;
  inherit elm-analyse elm-doc-preview;
}
