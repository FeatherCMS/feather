# syntax=docker/dockerfile:1.7

FROM swift:6.3.3-noble AS build

WORKDIR /build

# Keep package graph inputs in a layer independent from local Swift sources.
COPY application/Package.swift application/Package.resolved /build/application/
COPY modules/cms-account-module/Package.swift modules/cms-account-module/Package.resolved /build/modules/cms-account-module/
COPY modules/cms-analytics-module/Package.swift modules/cms-analytics-module/Package.resolved /build/modules/cms-analytics-module/
COPY modules/cms-auth-module/Package.swift modules/cms-auth-module/Package.resolved /build/modules/cms-auth-module/
COPY modules/cms-blog-module/Package.swift modules/cms-blog-module/Package.resolved /build/modules/cms-blog-module/
COPY modules/cms-contact-module/Package.swift modules/cms-contact-module/Package.resolved /build/modules/cms-contact-module/
COPY feather-core/Package.swift feather-core/Package.resolved /build/feather-core/
COPY modules/cms-media-module/Package.swift modules/cms-media-module/Package.resolved /build/modules/cms-media-module/
COPY modules/cms-news-module/Package.swift modules/cms-news-module/Package.resolved /build/modules/cms-news-module/
COPY modules/cms-newsletter-module/Package.swift modules/cms-newsletter-module/Package.resolved /build/modules/cms-newsletter-module/
COPY modules/cms-redirect-module/Package.swift modules/cms-redirect-module/Package.resolved /build/modules/cms-redirect-module/
COPY modules/cms-system-module/Package.swift modules/cms-system-module/Package.resolved /build/modules/cms-system-module/
COPY modules/cms-user-module/Package.swift modules/cms-user-module/Package.resolved /build/modules/cms-user-module/
COPY modules/cms-web-module/Package.swift modules/cms-web-module/Package.resolved /build/modules/cms-web-module/

WORKDIR /build/application

RUN --mount=type=cache,id=application-swiftpm,target=/root/.swiftpm,sharing=locked \
    --mount=type=cache,id=application-swift-cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,id=application-swift-build,target=/build/application/.build,sharing=locked \
    git config --global http.version HTTP/1.1 && \
    swift package resolve

COPY ./application /build/application
COPY ./feather-core /build/feather-core
COPY ./modules /build/modules

# Build every executable from one package/build stage.
RUN --mount=type=cache,id=application-swiftpm,target=/root/.swiftpm,sharing=locked \
    --mount=type=cache,id=application-swift-cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,id=application-swift-build,target=/build/application/.build,sharing=locked \
    swift build -c release --static-swift-stdlib --disable-automatic-resolution --manifest-cache local

WORKDIR /staging

RUN --mount=type=cache,id=application-swift-build,target=/build/application/.build,sharing=locked \
    BIN_PATH="$(swift build --package-path /build/application -c release --show-bin-path --disable-automatic-resolution --manifest-cache local)" && \
    mkdir -p /staging/backend /staging/web-app /staging/web-static && \
    cp "$BIN_PATH/Server" "$BIN_PATH/Migrator" "$BIN_PATH/Worker" /staging/backend/ && \
    cp "$BIN_PATH/WebApp" /staging/web-app/ && \
    cp "$BIN_PATH/WebStatic" /staging/web-static/ && \
    for resourceBundle in "$BIN_PATH"/*.resources "$BIN_PATH"/*.bundle; do \
        if [ -e "$resourceBundle" ]; then cp -Ra "$resourceBundle" /staging/web-app/; fi; \
    done

RUN mkdir -p /staging/web-app/application_WebApp.resources && \
    cp -Ra /build/application/Sources/WebApp/Resources/Templates/. /staging/web-app/application_WebApp.resources/

# FileMiddleware serves from the `public` directory relative to the process
# working directory. Preserve that directory in the static image.
RUN mkdir -p /staging/web-static/public && \
    cp -Ra /build/application/public/. /staging/web-static/public/

RUN cp "/usr/libexec/swift/linux/swift-backtrace-static" /staging/backend/

FROM alpine:3.22 AS application-artifacts

COPY --from=build /staging /artifacts
