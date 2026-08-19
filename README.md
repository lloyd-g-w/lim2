## Usage

```
nix run github:lloyd-g-w/lim2
nix build .#nvim
nix develop
```

## extraPackages

Edit the list in `nvim.nix`:

```nix
extraPackages = with pkgs; [
  ripgrep
  lua-language-server
];
```

## Home Manager

```nix
imports = [ inputs.lim2.homeManagerModules.default ];
programs.lim.enable = true;
```

### Params

- `enable` (bool, default `false`)
- `repo` (string | null, default `null`) — absolute path to a local checkout.
  When set, `~/.config/nvim/init.lua` is symlinked to `${repo}/init.lua`
  instead of copying it into the store, so edits apply without a rebuild.
