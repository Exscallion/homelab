#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash github-cli
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/25.11.tar.gz

echo "*** Running pre-flight checks..."
# This technically is not a reproducible script, as it relies on the host systems path.
# But importing nix, sudo etc. into this script is a hassle. But if you use my flake, you'll guarenteed have these packages.
# If you're really bothered by this technicality, then you're free to make a PR.

REQUIRED_CMDS=(nix sudo pkill hyprctl)
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "MISSING CMD $cmd;"
    echo "Please install $cmd on your system."
    exit 1
  else
    echo "FOUND CMD $cmd;"
  fi
done

echo "*** Verifying GitHub authentication"

if ! gh auth status > /dev/null 2>&1; then
  echo "Not logged in, follow instructions CLI suggests."
  gh auth login
else 
  GHTOKEN=$(gh auth token)
  export NIX_CONFIG="access-tokens = github.com=$GHTOKEN"
  
  echo "GitHub token: ${GHTOKEN:0:5}*****************************${GHTOKEN: -5}"
  echo "Updated NIX_CONFIG with access token."
fi

# Update our flake repository
echo "*** Updating userData flake from GitHub."
nix flake update userData

# Rebuild and switch.
echo "*** Rebuilding and switching to new NixOS generation"
sudo nixos-rebuild switch --flake .#palica

# Reload a bunch of stuff
echo "*** Restarting hyprpaper."
pkill hyprpaper
nohup hyprpaper >/dev/null 2>&1 &

echo "*** Reloading hyprland."
hyprctl reload

echo "*** All done!"