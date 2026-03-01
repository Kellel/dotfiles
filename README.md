Setup new laptop
===============

## Quick start

```bash
# 1) install nix and enable flakes
sh <(curl -L https://nixos.org/nix/install) --daemon
mkdir -p ~/.config/nix
cat <<'EOF' > ~/.config/nix/nix.conf
experimental-features = nix-command flakes
EOF

# 2) clone and apply
git clone <your-dotfiles-repo-url> ~/repos/dotfiles
cd ~/repos/dotfiles
home-manager switch --flake .#kellen
```

If `home-manager` is not available as a command:
```bash
nix run github:nix-community/home-manager -- switch --flake .#kellen
```

## 1) Bootstrap

Install Nix:
https://nixos.org/download
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Enable flakes (if not already enabled):
```bash
mkdir -p ~/.config/nix
cat <<'EOF' > ~/.config/nix/nix.conf
experimental-features = nix-command flakes
EOF
```

If Home Manager is not installed yet:
```bash
nix run github:nix-community/home-manager -- --version
```

## 2) Get your dotfiles

```bash
git clone <your-dotfiles-repo-url> ~/repos/dotfiles
cd ~/repos/dotfiles
```

## 3) Apply the state

```bash
cd ~/repos/dotfiles
home-manager switch --flake .#kellen
```

If `home-manager` is not a command yet:
```bash
nix run github:nix-community/home-manager -- switch --flake .#kellen
```

## 4) Update packages / inputs

```bash
cd ~/repos/dotfiles
nix flake update
```

Then re-apply the state:
```bash
home-manager switch --flake .#kellen
```

## 5) Re-apply after local edits

Every time you change config files, run:
```bash
cd ~/repos/dotfiles
home-manager switch --flake .#kellen
```

## Notes

- `flake.lock` is committed to keep your setup reproducible.
- `nvim.nix` receives `extraSpecialArgs.unstable` for plugins that still need the unstable package set.
