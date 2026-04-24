# dog-nose config

Personal dotfiles and system configuration managed with Nix + home-manager.

## Apply configuration

```bash
home-manager switch --flake .#dog-nose --impure
```

> `--impure` is required because `flake.nix` reads `$USER` and `$HOME` via `builtins.getEnv`.
