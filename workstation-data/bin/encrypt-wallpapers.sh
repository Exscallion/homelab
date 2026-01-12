#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/25.11.tar.gz

tar --exclude="*.tar*" \
    --exclude=".gitkeep" \
    -czvf files/wallpapers/wallpapers.tar.gz \
    -C files/wallpapers .

age -r $(cat ./files/secrets/homelab-workstation-wallpapers.age-pub) \
    -o ./files/wallpapers/wallpapers.tar.gz.age ./files/wallpapers/wallpapers.tar.gz

rm ./files/wallpapers/wallpapers.tar.gz