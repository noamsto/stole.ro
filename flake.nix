{
  description = "noam.stole.ro — Hugo site deployed to Cloudflare Workers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

      imports = [inputs.treefmt-nix.flakeModule];

      perSystem = {
        pkgs,
        config,
        ...
      }: {
        packages.default = pkgs.stdenvNoCC.mkDerivation {
          pname = "stole-ro";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [pkgs.hugo];

          buildPhase = ''
            runHook preBuild
            hugo --minify --destination public
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            cp -r public $out
            runHook postInstall
          '';

          meta.description = "Built static site for noam.stole.ro";
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            prettier.enable = true;
          };
          settings.formatter.prettier.excludes = ["layouts/**"];
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.hugo
            pkgs.wrangler
            pkgs.nodejs
            config.treefmt.build.wrapper
          ];
        };
      };
    };
}
