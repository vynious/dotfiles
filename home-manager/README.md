# Home Manager

Simple guide for this `home-manager/` setup.

## Use it

From repo root:

```bash
cd home-manager
nix run github:nix-community/home-manager -- switch --impure --flake .#default
```

After first run, you can use:

```bash
home-manager switch --impure --flake .#default
```

## When you change config

1. Edit `home.nix` (packages, shell, aliases, dotfiles).
2. Apply changes:

```bash
home-manager switch --impure --flake .#default
```

## Update dependencies

```bash
cd home-manager
nix flake update
home-manager switch --impure --flake .#default
```

## Add app config files (AeroSpace, Zed, etc.)

1. Put files in this repo (example: `../aerospace/.aerospace.toml`, `../zed/settings.json`).
2. Map them in `home.nix` under `home.file`.
3. Run `home-manager switch --impure --flake .#default`.

Example:

```nix
home.file = {
  ".aerospace.toml".source = ../aerospace/.aerospace.toml;
  ".config/zed/settings.json".source = ../zed/settings.json;
  ".config/zed/keymap.json".source = ../zed/keymap.json;
};
```

Note: In `home.file`, target paths are home-relative (no `~` prefix).

If you add multiple home configurations in `flake.nix`, select one explicitly with:
`home-manager switch --impure --flake .#your-config-name`
