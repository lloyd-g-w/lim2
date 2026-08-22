# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`lim2` is a personal Neovim configuration, packaged as a Nix flake. There is no
application build/test/lint pipeline — the "build" is producing a working `nvim` binary,
and the way to verify a change is to run it.

## Commands

```
nix run github:lloyd-g-w/lim2   # run nvim with this config, fetched from GitHub
nix build .#nvim                # build the nvim package locally (./result/bin/nvim)
nix develop                     # devShell with the configured nvim on PATH
```

There is no separate lint/test/format command — Nix eval errors and Lua runtime errors
(shown on `:messages` / at startup) are the primary feedback loop. To sanity-check a change
without a full Nix rebuild, run `nvim -u init.lua` from the repo root (add `-c "set rtp+=."`
if `lua/` modules need to resolve via `require`).

## Architecture

- `init.lua` — entry point. Sets core `vim.opt` options and global keymaps directly (not
  split into `lua/config/*`), then `require("plugins")`. `lua/config/{autocmds,keymaps,options}.lua`
  exist as stub files for future use but are currently empty and not required by anything.
- `lua/plugins/init.lua` — aggregates plugin modules; currently just `require("plugins.lsp")`.
  Add new plugin areas as new `lua/plugins/*.lua` files and require them here.
- `lua/plugins/lsp.lua` — uses `vim.pack.add` (Neovim's native plugin manager, not
  lazy.nvim/packer) to pull `nvim-lspconfig`, then `vim.lsp.enable({...})` with Neovim's
  built-in LSP client. `nvim-lspconfig` is used only for its bundled server configs
  (cmd/filetypes/root_markers) — no `.setup()` calls. Language servers themselves are NOT
  installed here; they come from `extraPackages` in `nvim.nix` and just need to be on PATH.
  To enable a new LSP: add the server binary to `extraPackages` in `nvim.nix`, then add its
  name (matching an nvim-lspconfig config name) to the `vim.lsp.enable({...})` list.
- `nvim.nix` — wraps `neovim-unwrapped` with `extraPackages` (LSP servers, formatters,
  ripgrep, etc.) on PATH via `makeWrapper`. Has a `bakeConfig` toggle:
  - `bakeConfig = true` (default; used by `nix run`/`nix build`/devShell): copies `init.lua` +
    `lua/` into the Nix store and forces Neovim to use it via `-u`, producing a fully
    self-contained/portable nvim.
  - `bakeConfig = false` (used by the Home Manager module): skips baking; Home Manager
    instead symlinks `~/.config/nvim` straight to the live repo checkout so edits apply
    without a rebuild.
- `flake.nix` — flake-parts based. Exposes `packages.default`/`packages.nvim` (the wrapped
  nvim), `apps.default` (runs it), `devShells.default`, and the system-independent
  `homeManagerModules.default` (from `home-manager.nix`).
- `home-manager.nix` — defines `programs.lim` (`enable`, `repo`) for consumers using Home
  Manager. When `repo` is set to an absolute path, `~/.config/nvim` is symlinked to that
  checkout (live-reload editing); when `repo` is null, the flake-baked config is installed
  instead (works out of the box, no live reload).

## Conventions

- Lua files use tabs for indentation (see `lua/plugins/lsp.lua`); `init.lua` itself uses
  spaces — match whichever convention the file you're editing already uses.
- Comments in `.lua`/`.nix` files explain *why*, not *what* — keep that style when adding
  config (see the header comments in `nvim.nix` and `lua/plugins/lsp.lua`).
- Keep `extraPackages` in `nvim.nix` as the single place where CLI tools (LSP servers,
  formatters, `ripgrep`, etc.) are declared for the wrapped `nvim`.
