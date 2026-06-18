# syntax=docker/dockerfile:1.7

FROM swift:6.3.2-noble AS build

WORKDIR /app

COPY openapi/Package.swift /app/openapi/Package.swift
COPY web-app/Package.swift /app/web-app/Package.swift
COPY web-app/Package.resolved /app/web-app/Package.resolved

WORKDIR /app/web-app

RUN --mount=type=cache,id=web-app-swiftpm,target=/root/.swiftpm,sharing=locked \
    --mount=type=cache,id=web-app-swift-cache,target=/root/.cache,sharing=locked \
    swift package resolve

COPY openapi/Sources /app/openapi/Sources
COPY web-app/Sources /app/web-app/Sources
COPY web-app/Tests /app/web-app/Tests
COPY web-app/public /app/web-app/public

RUN --mount=type=cache,id=web-app-swiftpm,target=/root/.swiftpm,sharing=locked \
    --mount=type=cache,id=web-app-swift-cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,id=web-app-build,target=/app/web-app/.build,sharing=locked \
    swift build -c release --product WebApp

WORKDIR /staging-root

RUN --mount=type=cache,id=web-app-build,target=/app/web-app/.build,sharing=locked \
    BIN_PATH="$(swift build --package-path /app/web-app -c release --show-bin-path)" && \
    mkdir -p /staging-root/app && \
    cp "$BIN_PATH/WebApp" /staging-root/app/WebApp && \
    find -L "$BIN_PATH/" \
        \( -regex '.*\\.resources$' -o -regex '.*\\.bundle$' \) \
        -exec cp -Ra {} /staging-root/app/ \; && \
    mkdir -p "/staging-root$BIN_PATH" && \
    find -L "$BIN_PATH/" \
        \( -regex '.*\\.resources$' -o -regex '.*\\.bundle$' \) \
        -exec cp -Ra {} "/staging-root$BIN_PATH/" \;

RUN --mount=type=cache,id=web-app-build,target=/app/web-app/.build,sharing=locked \
    BIN_PATH="$(swift build --package-path /app/web-app -c release --show-bin-path)" && \
    mkdir -p /staging-root/app/web-app_WebApp.resources && \
    cp -Ra /app/web-app/Sources/WebApp/Resources/. /staging-root/app/web-app_WebApp.resources/ && \
    mkdir -p "/staging-root$BIN_PATH/web-app_WebApp.resources" && \
    cp -Ra /app/web-app/Sources/WebApp/Resources/. "/staging-root$BIN_PATH/web-app_WebApp.resources/"

FROM swift:6.3.2-noble AS runtime

WORKDIR /app

COPY --from=build /staging-root/ /

EXPOSE 3456

CMD ["/app/WebApp"]
