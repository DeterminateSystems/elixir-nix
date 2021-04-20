let
  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixpkgs { };
in
pkgs.mkShell {
  name = "fmt";

  buildInputs = with pkgs; [
    nixpkgs-fmt
    findutils # find, xargs
  ];
}
