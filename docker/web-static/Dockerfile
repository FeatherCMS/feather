# syntax=docker/dockerfile:1.7

FROM swift:6.3.2-noble

WORKDIR /app

COPY openapi /app/openapi
COPY web-app /app/web-app

WORKDIR /app/web-app

RUN --mount=type=cache,id=web-static-swiftpm,target=/root/.swiftpm,sharing=locked \
    --mount=type=cache,id=web-static-swift-cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,id=web-static-build,target=/app/web-app/.build,sharing=locked \
    swift build -c release --product Static
RUN --mount=type=cache,id=web-static-build,target=/app/web-app/.build,sharing=locked \
    cp "$(swift build --package-path /app/web-app -c release --show-bin-path)/Static" /usr/local/bin/Static

EXPOSE 4567

CMD ["/usr/local/bin/Static"]
