Setup new laptop
================

1. Install nix
https://nixos.org/download
```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. Setup everything else
```
nix run . switch
```
