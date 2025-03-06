# Python mono-repo using UV, Pex, and Earthly

This repository contains an example of a monorepo setup using uv and pex for building python executables.

## Motivation

UV supports the dev part of python mono-repositories through workspaces. 
However, when it comes to shipping our code we want to bundle our code in such a way that each docker image
only contains the necessary dependencies.

While the [related uv proposal](https://github.com/astral-sh/uv/issues/5802) for `uv bundle` is still in the future this repository provides a recipe for how to bundle uv workspaces into executables that can be easily copied into docker images.

## How does it work?

The magic of the entire approach relies on two commands:

1. Compile the dependencies of a workspace, e.g. `./server`:

```bash
uv pip compile pyproject.toml -o dist/requirements.txt
```

2. Build the pex:

```bash
uv run pex \
-r dist/requirements.txt \
-o dist/bin.pex \
-e main \
--python-shebang '#!/usr/bin/env python3' \
--sources-dir=. \
--scie eager
```

The resulting pex file will also include a full python interpreter and is only portable given the same architecture
and exec format meaning that if you built this on MacOS it will not work on linux.

Once we have the pex we can easily copy it into a docker image that is custom for each app.
Here we do it with earthly, even though you could conceivably also have one `Dockerfile` per package.

The entire repositories build process can be run with `make build-images`

## The example repository

The repository consists of a library `lib/format` that is consumed by two different targets `server` and `cli`.

To produce the `pex` for either target


## Limitations

- To do cross platform builds you need to run the build script


## Comparison with other tools

I took this table [from](https://github.com/JasperHG90/uv-monorepo) here, but it perfectly echoes my sentiment.

While pants (or if you are very experienced Bazel) is the ultimate solution, it has a very steep learning curve
and is thus hard to adopt for small to medium-sized teams.

On the other end of the spectrum poetry provides a good development experience, but it relies on many non-standard
features and lacks good support for mono-repositories.
UV being the long awaited messiah of the python eco-system not only supports mono-repos via workspaces, but also
provides a global lock file and top performance.

|                  | Poetry              | UV           | Pants           |
| ---------------- | ------------------- | ------------ | --------------- |
| Simplicity       | 😃                  | 😃           | 😭              |
| Single lock file | 😭                  | 😍           | 🚀              |
| CI/CD            | 🤨                  | 🤨           | 🙂              |
| Docker builds    | 🤔                  | 😀           | 😭➡️🙂          |
| Speed            | 🤮                  | 🥰           | 😌              |
| **Verdict**      | Woefully inadequate | Happy medium | Too complicated |
