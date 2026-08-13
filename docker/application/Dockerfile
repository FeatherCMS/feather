# syntax=docker/dockerfile:1.7

FROM swift:6.3.3-noble AS build

WORKDIR /build

# Keep package graph inputs in a layer independent from local Swift sources.
COPY application/Package.swift application/Package.resolved /build/application/
COPY modules/app-account-module/Package.swift modules/app-account-module/Package.resolved /build/modules/app-account-module/
COPY modules/app-analytics-module/Package.swift modules/app-analytics-module/Package.resolved /build/modules/app-analytics-module/
COPY modules/app-auth-module/Package.swift modules/app-auth-module/Package.resolved /build/modules/app-auth-module/
COPY modules/app-blog-module/Package.swift modules/app-blog-module/Package.resolved /build/modules/app-blog-module/
COPY modules/app-contact-module/Package.swift modules/app-contact-module/Package.resolved /build/modules/app-contact-module/
COPY feather-core/Package.swift feather-core/Package.resolved /build/feather-core/
COPY modules/app-media-module/Package.swift modules/app-media-module/Package.resolved /build/modules/app-media-module/
COPY modules/app-news-module/Package.swift modules/app-news-module/Package.resolved /build/modules/app-news-module/
COPY modules/app-newsletter-module/Package.swift modules/app-newsletter-module/Package.resolved /build/modules/app-newsletter-module/
COPY modules/app-redirect-module/Package.swift modules/app-redirect-module/Package.resolved /build/modules/app-redirect-module/
COPY modules/app-system-module/Package.swift modules/app-system-module/Package.resolved /build/modules/app-system-module/
COPY modules/app-user-module/Package.swift modules/app-user-module/Package.resolved /build/modules/app-user-module/
COPY modules/app-web-module/Package.swift modules/app-web-module/Package.resolved /build/modules/app-web-module/

WORKDIR /build/application

RUN --mount=type=cache,id=application-swiftpm,target=/root/.swiftpm,sharing=locked \
    --mount=type=cache,id=application-swift-cache,target=/root/.cache,sharing=locked \
    --mount=type=cache,id=application-swift-build,target=/build/application/.build,sharing=locked \
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
    cp "$BIN_PATH/Static" /staging/web-static/ && \
    find -L "$BIN_PATH/" \
        \( -regex '.*\\.resources$' -o -regex '.*\\.bundle$' \) \
        -exec cp -Ra {} /staging/web-app/ \;

RUN mkdir -p /staging/web-app/application_WebApp.resources && \
    cp -Ra /build/application/Sources/WebApp/Resources/. /staging/web-app/application_WebApp.resources/

# FileMiddleware serves from the `public` directory relative to the process
# working directory. Preserve that directory in the static image.
RUN mkdir -p /staging/web-static/public && \
    cp -Ra /build/application/public/. /staging/web-static/public/

RUN cp "/usr/libexec/swift/linux/swift-backtrace-static" /staging/backend/

FROM scratch AS application-artifacts

COPY --from=build /staging /artifacts
