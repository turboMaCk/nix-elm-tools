{ elmi-to-json, writeScriptBin, stdenv }:
let
  # Patching binwrap by NoOp script
  binwrap = writeScriptBin "binwrap" ''
    #! ${stdenv.shell}
    echo "binwrap called: Returning 0"
    return 0
  '';
  binwrap-install = writeScriptBin "binwrap-install" ''
    #! ${stdenv.shell}
    echo "binwrap-install called: Doing nothing"
  '';
in
pkg:
pkg.override {
  buildInputs = [ binwrap binwrap-install ];

  # Manually install elmi-to-json binary
  postInstall = ''
    ln -sf ${elmi-to-json}/bin/elmi-to-json node_modules/elmi-to-json/bin/elmi-to-json
  '';
}
