#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/25.11.tar.gz

echo "==> Removing generations..."
/run/current-system/sw/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +5

echo "==> Collecting garbage..."
/run/current-system/sw/bin/nix-store --gc

echo "==> Optimizing nix store..."
/run/current-system/sw/bin/nix-store --optimise

echo "Happy days, enjoy your clean system!!"