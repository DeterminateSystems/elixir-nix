#!/usr/bin/env nix-shell
#!nix-shell fmt.nix -i bash

# check all files except nix/sources.nix, which is niv-generated
find . -path '*.nix' -not -path '*/sources.nix' | xargs nixpkgs-fmt --check
