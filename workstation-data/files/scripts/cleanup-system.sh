#!/bin/sh
set -euo pipefail

/run/current-system/sw/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +5
/run/current-system/sw/bin/nix-store --gc
/run/current-system/sw/bin/nix-store --optimise