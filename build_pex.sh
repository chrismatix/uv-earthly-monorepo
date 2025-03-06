#!/bin/bash

set -euo pipefail

# Check if the argument (local package path) is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <local_package_path>"
  exit 1
fi

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

# Build the pex
# TODO https://zameermanji.com/blog/2021/6/25/packaging-multi-platform-python-applications/

uv run pex \
-r dist/requirements.txt \
-o dist/bin.pex \
-e main \
--python-shebang '#!/usr/bin/env python3' \
--sources-dir=. \
--scie eager
# --platform manylinux2014_x86_64-cp-3.10.13-none \

#--platform macosx_11_0_arm64-cp-3.10.13-cp3.10.13m

#--platform manylinux2014_x86_64-cp-310-cp310-none \
#--platform macosx_11_0_arm64-cp-310-cp310m \

chmod +x dist/bin

echo "pex saved to dist/bin.pex."

