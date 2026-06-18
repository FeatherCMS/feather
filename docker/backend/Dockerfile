# syntax=docker/dockerfile:1.7

FROM swift:6.3.2-noble AS build

WORKDIR /build

COPY ./openapi /build/openapi
COPY ./backend /build/backend

WORKDIR /build/backend

RUN --mount=type=cache,target=/build/backend/.build \
    swift package clean

RUN --mount=type=cache,target=/root/.swiftpm \
    --mount=type=cache,target=/root/.cache \
    --mount=type=cache,target=/build/backend/.build \
    swift package resolve

RUN --mount=type=cache,target=/root/.swiftpm \
    --mount=type=cache,target=/root/.cache \
    --mount=type=cache,target=/build/backend/.build \
    swift build -c release --static-swift-stdlib

WORKDIR /staging

RUN --mount=type=cache,target=/build/backend/.build \
    cp "$(swift build --package-path /build/backend -c release --show-bin-path)/Server" ./
RUN --mount=type=cache,target=/build/backend/.build \
    cp "$(swift build --package-path /build/backend -c release --show-bin-path)/Migrator" ./
RUN --mount=type=cache,target=/build/backend/.build \
    cp "$(swift build --package-path /build/backend -c release --show-bin-path)/Worker" ./
RUN cp "/usr/libexec/swift/linux/swift-backtrace-static" ./
RUN --mount=type=cache,target=/build/backend/.build \
    find -L "$(swift build --package-path /build/backend -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} ./ \;

FROM ubuntu:noble AS runtime-base

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && rm -r /var/lib/apt/lists/*

RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app hummingbird

WORKDIR /app

ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

FROM runtime-base AS app-base

COPY --from=build --chown=hummingbird:hummingbird /staging /app

FROM app-base AS server

USER hummingbird:hummingbird

EXPOSE 8080

ENTRYPOINT ["/app/Server"]
CMD ["--hostname", "0.0.0.0", "--port", "8080"]

FROM app-base AS migrator

USER hummingbird:hummingbird

ENTRYPOINT ["/app/Migrator"]

FROM app-base AS worker

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q install -y --no-install-recommends ffmpeg ghostscript imagemagick \
    && apt-get -q dist-upgrade -y \
    && rm -r /var/lib/apt/lists/*

USER hummingbird:hummingbird

ENTRYPOINT ["/app/Worker"]
