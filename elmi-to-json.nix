{ pkgs ? import <nixpkgs> {} }:

let version = "0.19.3";
in with pkgs; {
  blob = stdenv.mkDerivation {
    name = "elmi-to-json-easy-${version}";
    inherit version;

    src =
      if stdenv.isDarwin then
        fetchurl {
          url = "https://github.com/stoeffel/elmi-to-json/releases/download/${version}/elmi-to-json-${version}-osx.tar.gz";
          sha256 = "0hz3nr0bi0dlrxrwpnrv11q66acy77flz90f0p4bj65rypkrc7h6";
        }
      else
        fetchurl {
          url = "https://github.com/stoeffel/elmi-to-json/releases/download/${version}/elmi-to-json-${version}-linux.tar.gz";
          sha256 = "021zwpqicymxn2sn4m521a0awrv1zlfsm63hs648ldl8242lks4m";
        };

    unpackPhase = ''
      mkdir -p $out/bin
      tar xf $src -C $out/bin
    '';

    dontInstall = true;
  };
}
