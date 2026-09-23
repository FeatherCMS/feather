// swift-tools-version:6.3
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    // .strictMemorySafety(),
    .treatAllWarnings(as: .error),
    // .enableUpcomingFeature("InternalImportsByDefault"),
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
    name: "app-redirect-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "RedirectDomain", targets: ["RedirectDomain"]),
        .library(name: "RedirectContracts", targets: ["RedirectContracts"]),
        .library(name: "RedirectApplication", targets: ["RedirectApplication"]),
        .library(name: "RedirectInfrastructure", targets: ["RedirectInfrastructure"]),
        .library(name: "RedirectBackend", targets: ["RedirectBackend"]),
        .library(name: "RedirectAdminAPI", targets: ["RedirectAdminAPI"]),
        .library(name: "RedirectAppAPI", targets: ["RedirectAppAPI"]),
        .library(name: "RedirectSharedOpenAPIGenerator", targets: ["RedirectSharedOpenAPIGenerator"]),
        .executable(name: "RedirectAdminOpenAPIGenerator", targets: ["RedirectAdminOpenAPIGenerator"]),
        .executable(name: "RedirectAppOpenAPIGenerator", targets: ["RedirectAppOpenAPIGenerator"]),
        .library(name: "RedirectFrontend", targets: ["RedirectFrontend"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.0.0"
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
        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
    ],
    targets: [
        .target(
            name: "RedirectContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core"),
            ],
            path: "Sources/Contracts",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "RedirectContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),

                .target(name: "RedirectDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),

                .target(name: "RedirectApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectSharedOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "RedirectAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "RedirectSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "RedirectAppOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "RedirectSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),

                .target(name: "RedirectInfrastructure"),
                .target(name: "RedirectAdminAPI"),
                .target(name: "RedirectAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),
                .product(name: "SystemContracts", package: "app-system-module"),
                .product(name: "SystemFrontend", package: "app-system-module"),

                .target(name: "RedirectContracts"),
                .target(name: "RedirectAdminAPI"),
                .target(name: "RedirectAppAPI"),
            ],
            path: "Sources/Composition/Frontend",
            swiftSettings: swiftSettings
        ),

        .testTarget(
            name: "RedirectDomainTests",
            dependencies: [
                .target(name: "RedirectDomain"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "RedirectApplicationTests",
            dependencies: [
                .target(name: "RedirectApplication"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "RedirectInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDatabasePostgres", package: "feather-database-postgres"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),

                .target(name: "RedirectInfrastructure"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
