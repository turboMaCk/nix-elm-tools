{ pkgs ? import <nixpkgs> {}, compiler ? "ghc864" }:

let
  version = "0.19.4";

  cabalPkg =
    { mkDerivation, aeson, async, base, binary, bytestring, containers
    , directory, filepath, hpack, optparse-applicative, safe-exceptions
    , stdenv, text
    }:
    mkDerivation {
      pname = "elmi-to-json";
      version = version;
      src = pkgs.fetchFromGitHub {
        owner = "stoeffel";
        repo = "elmi-to-json";
        rev = version;
        sha256 = "1hcggk4p3slhmfhzi6ah1h1jap34kiidbbf92jr4b7i0rwv1s18r";
      };
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

  blob = with pkgs;
    stdenv.mkDerivation {
      name = "elmi-to-json-${version}";
      inherit version;

      src =
        if stdenv.isDarwin then
          fetchurl {
            url = "https://github.com/stoeffel/elmi-to-json/releases/download/${version}/elmi-to-json-${version}-osx.tar.gz";
            sha256 = "1l0ny081lr3lvndcqfzrgznz9xajarjbihiwbf4hvb13bg3ngbj3";
          }
        else
          fetchurl {
            url = "https://github.com/stoeffel/elmi-to-json/releases/download/${version}/elmi-to-json-${version}-linux.tar.gz";
            sha256 = "1gccza38wfgyyhpb98710lwam85v1a3wnzjsbpkihs6cvwkwyj32";
          };

      unpackPhase = ''
        mkdir -p $out/bin
        tar xf $src -C $out/bin
      '';

      dontInstall = true;
    };

in {
  inherit blob;
  fromSource = pkgs.haskell.packages.${compiler}.callPackage cabalPkg {};
}
