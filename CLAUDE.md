# dog-nose config

Personal dotfiles and system configuration managed with Nix + home-manager.

## Apply configuration

```bash
home-manager switch --flake .#dog-nose
```

> `--impure` is no longer needed since username and homeDirectory are hardcoded in `flake.nix`.
