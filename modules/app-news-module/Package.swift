// swift-tools-version:6.3
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .strictMemorySafety(),
    .treatAllWarnings(as: .error),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .enableUpcomingFeature("StrictConcurrency"),
    .enableExperimentalFeature("SuppressedAssociatedTypes"),
    .enableExperimentalFeature("LifetimeDependence"),
    .enableExperimentalFeature("Lifetimes"),
    .unsafeFlags(
        ["-cross-module-optimization"],
        .when(configuration: .release)
    ),
]


let package = Package(
    name: "app-news-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "NewsDomain", targets: ["NewsDomain"]),
        .library(name: "NewsContracts", targets: ["NewsContracts"]),
        .library(name: "NewsApplication", targets: ["NewsApplication"]),
        .library(name: "NewsInfrastructure", targets: ["NewsInfrastructure"]),
        .library(name: "NewsAdminAPI", targets: ["NewsAdminAPI"]),
        .library(name: "NewsAppAPI", targets: ["NewsAppAPI"]),
        .library(name: "NewsSharedOpenAPIGenerator", targets: ["NewsSharedOpenAPIGenerator"]),
        .executable(name: "NewsAdminOpenAPIGenerator", targets: ["NewsAdminOpenAPIGenerator"]),
        .executable(name: "NewsAppOpenAPIGenerator", targets: ["NewsAppOpenAPIGenerator"]),
        .library(name: "NewsBackend", targets: ["NewsBackend"]),
        .library(name: "NewsFrontend", targets: ["NewsFrontend"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/mattpolzin/OpenAPIKit",
            from: "7.0.0"
        ),
        .package(
            url: "https://github.com/jpsim/Yams",
            from: "6.2.0"
        ),
        .package(
            url: "https://github.com/apple/swift-openapi-runtime",
            from: "1.12.1"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.27.0"
        ),
        .package(
            url: "https://github.com/swift-server/async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/swift-server/swift-openapi-async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-nio",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-nio-ssl",
            from: "2.34.0"
        ),
        .package(
            url: "https://github.com/BinaryBirds/swift-web-standards",
            exact: "1.0.0-beta.4"
        ),
        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
        .package(path: "../app-web-module"),
        .package(path: "../app-media-module"),
    ],
    targets: [
        .target(
            name: "NewsContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "WebDomain", package: "app-web-module"),

                .target(name: "NewsContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "WebApplication", package: "app-web-module"),

                .target(name: "NewsDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "MediaDomain", package: "app-media-module"),
                .product(name: "MediaInfrastructure", package: "app-media-module"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),

                .target(name: "NewsApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "NewsAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "NewsSharedOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "NewsAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "NewsAppOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "NewsSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "NewsBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherContracts", package: "feather-core"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),

                .target(name: "NewsApplication"),
                .target(name: "NewsInfrastructure"),
                .target(name: "NewsAdminAPI"),
                .target(name: "NewsAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),

                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "MediaFrontend", package: "app-media-module"),
                .product(name: "SystemContracts", package: "app-system-module"),
                .product(name: "WebContracts", package: "app-web-module"),
                .product(name: "WebFrontend", package: "app-web-module"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "WebBuilders", package: "swift-web-standards"),
                .product(name: "WebComponents", package: "swift-web-standards"),
                .target(name: "NewsContracts"),
                .target(name: "NewsAdminAPI"),
                .target(name: "NewsAppAPI"),
            ],
            path: "Sources/Composition/Frontend",
            resources: [
                .copy("Resources/Templates")
            ],
            swiftSettings: swiftSettings
        ),
        // MARK: - tests
        .testTarget(
            name: "NewsModuleTests",
            dependencies: [
                .target(name: "NewsApplication"),
                .target(name: "NewsDomain"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "NewsFrontendTests",
            dependencies: [
                .target(name: "NewsFrontend"),
                .product(name: "Hummingbird", package: "hummingbird"),
            ],
            path: "Tests/NewsFrontendTests",
            swiftSettings: swiftSettings
        ),
    ]
)
