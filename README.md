Setup new laptop
================

1. Install nix
https://nixos.org/download
```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. Setup home manager
```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

3. Run config
```
home-manager -f home.nix switch
```
