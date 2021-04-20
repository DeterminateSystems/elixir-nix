# elixir-nix

This repository provides a derivation for building the [Elixir Cross
Referencer](https://github.com/bootlin/elixir).

By running `nix-build`, a `result` symlink will be generated in the current
directory; all of the scripts and tools from the Elixir repository are present
and have been wrapped to include all of the necessary dependencies.

Example usage:

```shell
export LXR_REPO_DIR=$PWD/elixir-data/nix/repo
export LXR_DATA_DIR=$PWD/elixir-data/nix/data

mkdir -p $LXR_REPO_DIR
mkdir -p $LXR_DATA_DIR

git clone https://github.com/NixOS/nix.git $LXR_REPO_DIR

./result/script.sh list-tags # list tags of that git repo
./result/update.py # create the database

./result/query.py 2.3.10 ident initPlugins CC # get definitions and references of the specified identifier
./result/query.py 2.3.10 file /src/nix-store/nix-store.cc # get the specified source file
```
