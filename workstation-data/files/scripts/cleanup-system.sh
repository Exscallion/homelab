#!/bin/sh
set -euo pipefail

nix-env --profile /nix/var/nix/profiles/system --delete-generations +5
nix-store --gc
nix-store --optimise