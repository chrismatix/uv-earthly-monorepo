# Python mono-repo using UV, Pex, and Earthly

This repository contains an example of a monorepo setup using uv and pex for building python executables.

## Motivation

UV supports the dev part of python mono-repositories through workspaces. 
However, when it comes to shipping our code we want to bundle our code in such a way that each docker image
only contains the necessary dependencies.

While the [related uv proposal](https://github.com/astral-sh/uv/issues/5802) for `uv bundle` is still in the future this repository provides a recipe for how to bundle uv workspaces into executables that can be easily copied into docker images. 

## Comparison with other tools

I took this table [from](https://github.com/JasperHG90/uv-monorepo) here, but it perfectly echoes my sentiment. 

|                  | Poetry              | UV           | Pants           |
| ---------------- | ------------------- | ------------ | --------------- |
| Simplicity       | 😃                  | 😃           | 😭              |
| Single lock file | 😭                  | 😍           | 🚀              |
| CI/CD            | 🤨                  | 🤨           | 🙂              |
| Docker builds    | 🤔                  | 😀           | 😭➡️🙂          |
| Speed            | 🤮                  | 🥰           | 😌              |
| **Verdict**      | Woefully inadequate | Happy medium | Too complicated |
