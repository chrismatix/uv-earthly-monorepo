VERSION 0.8

build-container:
    # Run this in the docker file, because earthly does not support COPY --from
    FROM DOCKERFILE -f Dockerfile.build .

    WORKDIR build
    COPY pyproject.toml uv.lock /build
    RUN uv tool install pex
    RUN uv sync

    SAVE IMAGE build-container
