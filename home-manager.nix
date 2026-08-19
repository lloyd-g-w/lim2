{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.lim;
in {
  options.programs.lim = {
    enable = lib.mkEnableOption "lim 2! neovim config";

    repo = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/home/lloyd/projects/lim2";
      description = ''
        Absolute path to a local checkout of the lim2 repo. When set,
        init.lua is symlinked from here into ~/.config/nvim (not
        copied into the Nix store), so editing it takes effect the
        next time you open Neovim — or immediately with :source % —
        no rebuild needed.

        When null (the default), the init.lua baked into this flake
        is used instead (fetched from GitHub, same as any other
        flake input) — works out of the box, but no live reload.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [(import ./nvim.nix {inherit pkgs; bakeConfig = cfg.repo == null;})];

    xdg.configFile."nvim/init.lua".source = lib.mkIf (cfg.repo != null)
      (config.lib.file.mkOutOfStoreSymlink "${cfg.repo}/init.lua");
  };
}
