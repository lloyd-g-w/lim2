# Neovim wrapped with whatever packages you list below on its PATH
# (LSP servers, ripgrep, formatters, ...). Edit the list directly.
#
# `bakeConfig` (default true): copy init.lua into the Nix store and
# force it with `-u`, producing a fully self-contained, portable nvim.
# This is what `nix run` / `nix build` / the devShell use.
#
# Home Manager passes bakeConfig = false and instead symlinks init.lua
# straight from your live repo checkout into ~/.config/nvim, so edits
# apply instantly (no rebuild) — see home-manager.nix.
{ pkgs, bakeConfig ? true }:
let
  extraPackages = with pkgs; [
    # ripgrep
    # lua-language-server
  ];

  base =
    if bakeConfig
    then pkgs.wrapNeovim pkgs.neovim-unwrapped {
      configure.customRC = ''
        luafile ${./init.lua}
      '';
    }
    else pkgs.neovim-unwrapped;
in
pkgs.symlinkJoin {
  name = "nvim";
  paths = [ base ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --prefix PATH : ${pkgs.lib.makeBinPath extraPackages}
  '';
  meta.mainProgram = "nvim";
}
