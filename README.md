# my nixos config

I'm very new to nix and nixos, so this repo is very wip.

install by
```
git clone https://github.com/luksab/nixos.git
sudo nixos-rebuild switch --flake .
```

# krops
- make sure `/var/src/.populate` exists.
```
nix-build ./krops.nix -A all && ./result
```

# TODO
- suckless as home module
- mouse vanish after 2 seconds
- fix graphics glitches on laptop
## look at:
- configuration options generated from nix code (low priority)
