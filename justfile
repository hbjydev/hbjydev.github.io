update:
  nix flake update

build package='default':
  #!/usr/bin/env bash
  deriv=$(nix build --no-link --json --print-build-logs ".?submodules=1#{{package}}")
  dist=$(echo $deriv | jq -r .[0].outputs.out)
  rm -rf public
  cp -r $dist public
  chmod -R +w public
