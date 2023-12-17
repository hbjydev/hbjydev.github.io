update:
  nix flake update


build package='default':
  #!/usr/bin/env bash
  deriv=$(nix build --json --print-build-logs ".?submodules=1#{{package}}")
  dist=$(echo $deriv | jq -r .[0].outputs.out)
  echo "Built to $dist"

run port='9090':
  #!/usr/bin/env bash
  deriv=$(nix build --json --print-build-logs ".?submodules=1#default")
  dist=$(echo $deriv | jq -r .[0].outputs.out)
  echo "Built to $dist"
  nix develop -c updog --directory $dist --port {{ port }}
