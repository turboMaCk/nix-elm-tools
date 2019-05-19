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
      inherit (pkgs) lib writeScriptBin stdenv;
    };
in
with elmNodePackages;
{
  elm-test = patchBinwrap [elmi-to-json] elm-test;
  elm-verify-examples = patchBinwrap [elmi-to-json] elm-verify-examples;
  inherit elm-analyse elm-doc-preview elmi-to-json elm-upgrade;
}
