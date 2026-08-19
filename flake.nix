{
  description = "lim 2!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # System-independent outputs.
      flake = {
        homeManagerModules.default = ./home-manager.nix;
      };

      # System-dependent outputs.
      perSystem = {pkgs, ...}: let
        nvim = import ./nvim.nix {inherit pkgs;};
      in {
        # `nix build` / consumed as a package.
        packages.default = nvim;
        packages.nvim = nvim;

        # `nix run` starts Neovim with the config applied.
        apps.default = {
          type = "app";
          program = "${nvim}/bin/nvim";
        };

        # `nix develop` drops you into a shell with the configured Neovim.
        devShells.default = pkgs.mkShell {
          packages = [nvim];
        };
      };
    };
}
