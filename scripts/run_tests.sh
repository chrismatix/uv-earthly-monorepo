#!/bin/bash

members=$(uv run python -c 'import tomli; print("\n".join(tomli.load(open("pyproject.toml", "rb"))["tool"]["uv"]["workspace"]["members"]))')

echo $members

for dir in $members; do
    echo "Testing $dir..."
    (cd "$dir" && uv run pytest) || exit 1
done
