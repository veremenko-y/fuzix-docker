#!/usr/bin/env bash
set -euo pipefail

docker build -t fuzix-build .
docker run --rm -it --volume $(pwd):/workdir fuzix-build
