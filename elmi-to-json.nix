{ pkgs ? import <nixpkgs> {} }:

let
  version = "0.19.3";
  sha256 = "";

  elmi-to-json =
    pkgs.fetchFromGitHub {
      rev = version;
      owner = "stoeffel";
      repo = "elmi-to-json";
      sha256 = "0s32929q1xfqnrh5lv1xjhw5wmjdcm4c19hkdg8835px4kir9899";
    };
in with pkgs;
  # (pkgs.haskellPackages.stack2nix "elmi-to-json-${version}" elmi-to-json {})
  { blob = stdenv.mkDerivation {
        name = "elmi-to-json-easy-${version}";
        inherit version;

        src = fetchurl {
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
