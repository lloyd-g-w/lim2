{
  description = "lim 2!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/a32edd7654519351e48e80372a928df336394670";
    flake-parts.url = "github:hercules-ci/flake-parts";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
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
        homeManagerModules.default = {pkgs, ...} @ args:
          import ./home-manager.nix (args
            // {
              pkgs = pkgs.extend inputs.neovim-nightly.overlays.default;
            });
      };

      # System-dependent outputs.
      perSystem = {pkgs, ...}: let
        nightlyPkgs = pkgs.extend inputs.neovim-nightly.overlays.default;

        nvim = import ./nvim.nix {
          pkgs = nightlyPkgs;
        };
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
