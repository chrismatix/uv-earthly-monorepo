#!/bin/bash

# TODO This file is still WIP
# Goal: Build the pex file while mounting the repository into a container
# matching the target platform
# Issues:
# - The editable file:/// resolve in the requirements.txt uses an absolute path

set -euo pipefail

# Check if the argument (local package path) is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <local_package_path>"
  exit 1
fi

# Build the build-container
earthly +build-container

# Navigate to the specified package path
PACKAGE_PATH="$1"

if [ -d "$PACKAGE_PATH" ]; then
  cd "$PACKAGE_PATH" || { echo "Failed to cd into $PACKAGE_PATH"; exit 1; }
else
  echo "Directory $PACKAGE_PATH does not exist."
  exit 1
fi

# Generate the package specific requirements txt
uv pip compile pyproject.toml --universal -o dist/requirements.txt --quiet

echo "Compiled requirements.txt"

# Build the pex
docker run --rm -v "$(pwd):/app" -w /build build-container \
uv run pex \
-r dist/requirements.txt \
-o dist/bin.pex \
-e main \
--python-shebang '#!/usr/bin/env python3' \
--sources-dir=. \
--scie eager

chmod +x dist/bin

echo "artifacts in dist:"
ls dist
