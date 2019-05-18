{ writeScriptBin, stdenv, lib }:
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
targets:
pkg:
pkg.override {
  buildInputs = [ binwrap binwrap-install ];

  # Manually install targets
  # by symlinking binaries into `node_modules`
  postInstall = ''
    ${lib.concatStrings (map (module: ''
        echo "linking ${module.nodePackageName}"
        ln -sf ${module}/bin/${module.nodePackageName} \
            node_modules/${module.nodePackageName}/bin/${module.nodePackageName}
    '') targets)}
  '';
}
