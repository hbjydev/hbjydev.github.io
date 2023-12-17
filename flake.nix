{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-23.11";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem = { self', pkgs, ... }:
        let
          inherit (pkgs) just hugo;
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = [ just ];
            inputsFrom = [ self'.packages.dist ];
          };

          packages = {
            dist = pkgs.runCommand "dist" {
              src = ./.;
              buildInputs = [ hugo ];
            } ''
              work=$(mktemp -d)
              cp -r $src/* $work
              (cd $work && hugo)
              cp -r $work/public $out
            '';
          };
        };
    };
}
