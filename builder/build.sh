#!/usr/bin/env bash

set -feuo pipefail
IFS=$'\n\t'

ghc_options=${ghc_options:--static -optl-static -optl-pthread}
socket=/var/run/docker.sock
file=$dockerfile

echo "Building..."
stack setup "$(ghc --numeric-version)" --skip-ghc-check
stack build --ghc-options "$ghc_options" -- .

# Strip all statically linked executables
find "$(stack path --dist-dir)/build" \
  -type f \
  -perm -u=x,g=x,o=x \
  -exec strip --strip-all --enable-deterministic-archives --preserve-dates {} +

if [ -S $socket ] && [ -r $socket ] && [ -w $socket ] && [ -f $file ] && [ -r $file ]; then
  ln -snf -- "$(stack path --dist-dir)/build" .
  ls build
fi
