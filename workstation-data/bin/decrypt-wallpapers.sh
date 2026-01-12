#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/25.11.tar.gz

age --decrypt -i ~/.secrets/homelab_workstation_wallpapers.age-priv -o ../files/wallpapers/wallpapers.tar.gz ../files/wallpapers/wallpapers.tar.gz.age
# tar -czvf ../files/wallpapers/wallpapers.tar.gz ../files/wallpapers