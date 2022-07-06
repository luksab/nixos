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

# patch individual executables
- get requirements
```
nix-shell -p file patchelf
```
- get current interpreter
```
file $(which file)
```
- patch
```
sudo patchelf --set-interpreter [interpreter] [executable]
```

# setup pre-commit hook
```
nix-shell -p pre-commit --run "pre-commit install"
```
