!#/bin/bash

# Update our flake repository
nix flake update selfRepository

# Rebuild and switch.
sudo nixos-rebuild switch --flake .#palica

# Reload a bunch of stuff
pkill hyprpaper
nohup hyprpaper >/dev/null 2>&1 &
hyprctl reload