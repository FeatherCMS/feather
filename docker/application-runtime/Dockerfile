# syntax=docker/dockerfile:1.7

ARG ARTIFACT_IMAGE=feather-cms-application-artifacts

FROM ${ARTIFACT_IMAGE} AS artifacts

FROM ubuntu:noble AS backend-runtime-base

RUN --mount=type=cache,id=application-apt-archives,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=application-apt-lists,target=/var/lib/apt/lists,sharing=locked \
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q install -y --no-install-recommends ca-certificates

RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app hummingbird

WORKDIR /app

ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

FROM backend-runtime-base AS backend

COPY --from=artifacts --chown=hummingbird:hummingbird /artifacts/backend /app

FROM backend AS server

USER hummingbird:hummingbird

EXPOSE 8080

ENTRYPOINT ["/app/Server"]
CMD ["--hostname", "0.0.0.0", "--port", "8080"]

FROM backend AS migrator

USER hummingbird:hummingbird

ENTRYPOINT ["/app/Migrator"]

FROM backend-runtime-base AS worker-runtime

RUN --mount=type=cache,id=application-apt-archives,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=application-apt-lists,target=/var/lib/apt/lists,sharing=locked \
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q install -y --no-install-recommends ffmpeg ghostscript imagemagick

FROM worker-runtime AS worker

COPY --from=artifacts --chown=hummingbird:hummingbird /artifacts/backend /app

USER hummingbird:hummingbird

ENTRYPOINT ["/app/Worker"]

FROM swift:6.3.3-noble AS web-app

WORKDIR /app

COPY --from=artifacts /artifacts/web-app /app

EXPOSE 3456

CMD ["/app/WebApp"]

FROM swift:6.3.3-noble AS web-static

WORKDIR /app

COPY --from=artifacts /artifacts/web-static /app

EXPOSE 4567

CMD ["/app/Static"]
