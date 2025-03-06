
build-container:
    FROM python:3.10-slim-bookworm
    COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

    COPY pyproject.toml uv.lock .
    RUN uv sync

    SAVE IMAGE build-container
