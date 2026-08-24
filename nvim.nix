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
{
  pkgs,
  bakeConfig ? true,
}: let
  extraPackages = with pkgs; [
    # For image.nvim plugin
    luajitPackages.magick
    imagemagick
    luarocks
    lua5_1

    # copilot.lua runs its bundled language server with `node`
    nodejs

    lazygit
    tree-sitter
    texpresso
    tectonic
    ripgrep

    nixd
    texlab
    lua-language-server
    svelte-language-server
    jdt-language-server
    typescript-language-server
    vim-language-server
    basedpyright
    csharp-ls
    cmake-language-server
    tailwindcss-language-server
    tinymist
    rust-analyzer
    zls
    qt6Packages.qtdeclarative
    haskell-language-server
    ocaml
    ocamlPackages.ocaml-lsp

    # C++
    # clang-tools also bundles clangd, but it doesn't resolve stdlib
    # headers correctly — only use it for clang-format, not as clangd's
    # source.
    clang-tools

    tex-fmt
    rustfmt
    markdownlint-cli
    alejandra
    yq-go
    black
    jq
    stylua
    astyle
    prettier
    ocamlPackages.ocamlformat

    # vscode-extensions.ms-vscode.cpptools
    gdb
  ];

  # init.lua + lua/ only — this is what gets put on `runtimepath` so
  # `require(...)` can find lua/plugins/*.lua etc.
  configDir = pkgs.lib.fileset.toSource {
    root = ./.;
    fileset = pkgs.lib.fileset.unions [./init.lua ./lua];
  };

  base =
    if bakeConfig
    then
      pkgs.wrapNeovim pkgs.neovim-unwrapped {
        configure.customRC = ''
          set runtimepath^=${configDir}
          luafile ${configDir}/init.lua
        '';
      }
    else pkgs.neovim-unwrapped;
in
  pkgs.symlinkJoin {
    name = "nvim";
    paths = [base];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/nvim \
        --prefix PATH : ${pkgs.lib.makeBinPath extraPackages}
    '';
    # Exposed so home-manager.nix can also install these into the user
    # profile (usable from any terminal), not just on nvim's wrapped PATH.
    passthru = {inherit extraPackages;};
    meta.mainProgram = "nvim";
  }
