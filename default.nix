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
in rec {
  elm-test = patchBinwrap [elmi-to-json] elmNodePackages.elm-test;
  elm-verify-examples = patchBinwrap [elmi-to-json] elmNodePackages.elm-verify-examples;
  elm-language-server = elmNodePackages."@elm-tooling/elm-language-server".override {
    buildInputs = [ pkgs.elmPackages.elm pkgs.elmPackages.elm-format elm-test ];
  };
  inherit elmi-to-json;
  inherit (elmNodePackages) elm-analyse elm-doc-preview elm-upgrade;
}
