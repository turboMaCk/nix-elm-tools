{ pkgs ? import <nixpkgs> {}, compiler ? "ghc864" }:

let
  version = "0.19.3";

  src = pkgs.fetchFromGitHub {
    owner = "stoeffel";
    repo = "elmi-to-json";
    # using tag for consistency with bloc fetch
    rev = version;
    sha256 = "0s32929q1xfqnrh5lv1xjhw5wmjdcm4c19hkdg8835px4kir9899";
  };

  cabalPkg =
    { mkDerivation, aeson, async, base, binary, bytestring, containers
    , directory, filepath, hpack, optparse-applicative, safe-exceptions
    , stdenv, text
    }:
    mkDerivation {
      pname = "elmi-to-json";
      version = "0.1.0.0";
      src = src;
      patches = [ ./patches/elmi-to-json.patch ];
      isLibrary = true;
      isExecutable = true;
      libraryHaskellDepends = [
        aeson async base binary bytestring containers directory filepath
        optparse-applicative safe-exceptions text
      ];
      libraryToolDepends = [ hpack ];
      executableHaskellDepends = [ base ];
      testHaskellDepends = [ base ];
      preConfigure = "hpack";
      homepage = "https://github.com/stoeffel/elmi-to-json#readme";
      license = stdenv.lib.licenses.bsd3;
    };

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

  fromSource =
    pkgs.haskell.packages.${compiler}.callPackage cabalPkg {};
}
