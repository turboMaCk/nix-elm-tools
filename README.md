# Nix Elm Tools

[![Build Status](https://travis-ci.org/turboMaCk/nix-elm-tools.svg?branch=master)](https://travis-ci.org/turboMaCk/nix-elm-tools)

[Elm](https://elm-lang.org/) lang community tooling
for the [Nix package manager](https://nixos.org/nix/) and [NixOS](http://nixos.org)
operating system.

## Motivation

Getting all the existing community tooling for Elm language setuped with nix is painful.
This is mostly due to the usage of binary wrappers and mixtures of
haskell binaries and node.js based parts of tooling. For instance `nodePackages.elm-test`
provided by [nixpkgs](https://github.com/NixOS/nixpkgs)
isn't working. I believe this situation can be improved!
Generally there are two ways to do so:

1. Remove all the hacks in upstream packages to make them nix compatible by default.
2. Implement custom nix builds specific to elm tooling with patches for the issues.

Given that nix users makes only tiny fraction of the users of those tools I think
it would be naive to impose restrictions and push more work on tooling maitainers
and therefore this project uses 2nd approach to provide elm lang tooling to nix community.

## Rules

These are the rules followed:

1. [x] Builds on NixOS
2. [x] Builds are reasonably fast (eg. we avoid usage of stack2nix and large rebuilds of Haskell packages)
3. [x] Easy to pull from remote
4. [x] Nixpkgs like conventions
5. [x] Linux and MacOS portability
6. [x] Utilizing existing nix tooling

## Components

So far we provide these tools:

- [elm-test](https://github.com/rtfeldman/node-test-runner)
- [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples)
- [elm-analyse](https://github.com/stil4m/elm-analyse)
- [elm-doc-preview](https://github.com/dmy/elm-doc-preview)

If you miss your favorite tool feel free to open an issue or send a PR.

## Usage

Instal a tool from source:

```shell
# clone project
$ git clone https://github.com/turboMaCk/nix-elm-tools.git
$ cd nix-elm-tools

# install elm-test
$ nix-env -f default.nix -iA elm-test
installing 'node-elm-test-0.19.0-rev6'
building '/nix/store/bf69nj0mzfqajgip1bpxwg05y1zh7191-user-environment.drv'...
created 21 symlinks in user environment
```

Dotfiles remote install:

```nix
let
  pkgs = import <nixpkgs> {};

  elmTools = import (pkgs.fetchFromGitHub {
    owner = "turboMaCk";
    repo = "nix-elm-tools";
    rev = "";
    sha256 = "";
  }) { inherit pkgs; };
in
{
  inherit (elmTools) elm-test elm-verify-examples;
}
```

Project nix-shell remote install:

```nix
{ pkgs ? import <nixpkgs> {} }:
let
  elmTools = import (pkgs.fetchFromGitHub {
    owner = "turboMaCk";
    repo = "nix-elm-tools";
    rev = "";
    sha256 = "";
  }) { inherit pkgs; };
in
  with pkgs;
  mkShell {
    buildInputs = with elmTools; [ elm-test elm-verify-examples ];
  }
```

NixOS configuration remote install:

```nix
{ pkgs, ... }:

let
  elmTools = import (pkgs.fetchFromGitHub {
    owner = "turboMaCk";
    repo = "nix-elm-tools";
    rev = "e2014925d60867c1e8f07e4bd5cbaeec3a484fff";
    sha256 = "10v3h3mmxx20dn93nwsm86grd3qqzllsyf46m6bj6d8grxfil3x8";
  }) { inherit pkgs; };
in {
    environment.systemPackages = with pkgs.elmPackages; [
        elm
        elm-format
        pkgs.elm2nix
        elmTools.elm-test
        elmTools.elm-verify-examples
        elmTools.elm-analyse
        elmTools.elm-doc-preview
    ];
}
```

## Developement

All contributions are welcome. If you want to add a tool available via npm
add it to `packages.json` and genereta new files using script.

```
$ ./generate.sh
```

In order to make to expose the tool to users,
edit the `default.nix` file and expose it.
In case tool depends on `elmi-to-json` binary (usually installed)
via npm with `binwrap` apply the patch (see `elm-test` as an example).

## Get More!

If you're nix user you should definitely try awesome [elm2nix](https://github.com/hercules-ci/elm2nix).
Big shouts to [@domenkozar](https://github.com/hercules-ci/elm2nix/commits?author=domenkozar)
and the whole [herokus-ci](https://hercules-ci.com/) for their work.
