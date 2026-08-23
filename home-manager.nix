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
        ~/.config/nvim is symlinked to this directory (not copied into
        the Nix store), so editing init.lua or lua/**/*.lua takes
        effect the next time you open Neovim — or immediately with
        :source % — no rebuild needed.

        When null (the default), the config baked into this flake is
        used instead (fetched from GitHub, same as any other flake
        input) — works out of the box, but no live reload.
      '';
    };
  };

  config = lib.mkIf cfg.enable (let
    nvim = import ./nvim.nix {inherit pkgs; bakeConfig = cfg.repo == null;};
  in {
    # Install nvim's CLI tools (LSPs, formatters, ...) into the profile
    # too, so they're runnable from any terminal, not only inside nvim.
    home.packages = [nvim] ++ nvim.extraPackages;

    xdg.configFile."nvim".source = lib.mkIf (cfg.repo != null)
      (config.lib.file.mkOutOfStoreSymlink cfg.repo);
  });
}
