{ pkgs ? import <nixpkgs> {}}:
let
  elmi-to-json =
    (import ./elmi-to-json.nix { inherit pkgs; }).blob;

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
