// swift-tools-version:6.3
import PackageDescription

var swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    // .strictMemorySafety(),
    .treatAllWarnings(as: .error),
    .enableUpcomingFeature("ExistentialAny"),
    // .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .enableUpcomingFeature("LifetimeDependence"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    .enableExperimentalFeature("LifetimeDependence"),
    .enableExperimentalFeature("Lifetimes"),
    .enableExperimentalFeature("StrictConcurrency=complete"),
    .unsafeFlags(
        ["-cross-module-optimization"],
        .when(configuration: .release)
    ),
]

let package = Package(
    name: "app-web-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "WebDomain", targets: ["WebDomain"]),
        .library(name: "WebContracts", targets: ["WebContracts"]),
        .library(name: "WebApplication", targets: ["WebApplication"]),
        .library(name: "WebInfrastructure", targets: ["WebInfrastructure"]),
        .library(name: "WebAdminAPI", targets: ["WebAdminAPI"]),
        .library(name: "WebAppAPI", targets: ["WebAppAPI"]),
        .library(name: "WebBackend", targets: ["WebBackend"]),
        .library(name: "WebFrontend", targets: ["WebFrontend"]),
        .library(name: "WebSharedOpenAPIGenerator", targets: ["WebSharedOpenAPIGenerator"]),
        .executable(name: "WebAdminOpenAPIGenerator", targets: ["WebAdminOpenAPIGenerator"]),
        .executable(name: "WebAppOpenAPIGenerator", targets: ["WebAppOpenAPIGenerator"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.15.0"
        ),
        .package(
            url: "https://github.com/mattpolzin/OpenAPIKit",
            from: "5.0.0"
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
            url: "https://github.com/feather-framework/feather-database-postgres",
            exact: "1.0.0-rc.2"
        ),
        .package(
            url: "https://github.com/vapor/postgres-nio",
            from: "1.32.2"
        ),
        .package(
            url: "https://github.com/apple/swift-nio-ssl",
            from: "2.34.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-mustache",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-markdown",
            from: "0.8.0"
        ),
        .package(path: "../../feather-core"),
        .package(path: "../app-media-module"),
        .package(path: "../app-system-module"),
    ],
    targets: [
        .target(
            name: "WebContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WebDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "WebContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WebApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),

                .product(name: "SystemContracts", package: "app-system-module"),
                .product(name: "SystemApplication", package: "app-system-module"),

                .target(name: "WebDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WebInfrastructure",
            dependencies: [
                .product(name: "SystemInfrastructure", package: "app-system-module"),

                .target(name: "WebApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "WebAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WebAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "WebSharedOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "WebAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "WebSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "WebAppOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "WebSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "WebBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),

                .target(name: "WebInfrastructure"),
                .target(name: "WebAdminAPI"),
                .target(name: "WebAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WebFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),
                .product(name: "Markdown", package: "swift-markdown"),
                .product(name: "Mustache", package: "swift-mustache"),
                .product(name: "SystemContracts", package: "app-system-module"),

                .target(name: "WebContracts"),
                .target(name: "WebAdminAPI"),
                .target(name: "WebAppAPI"),
                .product(name: "SystemAdminAPI", package: "app-system-module"),
                .product(name: "SystemFrontend", package: "app-system-module"),
                .product(name: "MediaFrontend", package: "app-media-module")
            ],
            path: "Sources/Composition/Frontend",
            resources: [
                .copy("Resources/Templates")
            ],
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .testTarget(
            name: "WebDomainTests",
            dependencies: [
                .target(name: "WebDomain")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "WebApplicationTests",
            dependencies: [
                .target(name: "WebApplication")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "WebInfrastructureTests",
            dependencies: [
                .target(name: "WebInfrastructure"),

                .product(name: "FeatherDatabasePostgres", package: "feather-database-postgres"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
