// swift-tools-version:6.3
import PackageDescription

var swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    // .strictMemorySafety(),
    // .treatAllWarnings(as: .error),
    .enableUpcomingFeature("ExistentialAny"),
    // .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .enableUpcomingFeature("LifetimeDependence"),
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
    name: "app-media-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "MediaDomain", targets: ["MediaDomain"]),
        .library(name: "MediaContracts", targets: ["MediaContracts"]),
        .library(name: "MediaApplication", targets: ["MediaApplication"]),
        .library(name: "MediaInfrastructure", targets: ["MediaInfrastructure"]),
        .library(name: "MediaAdminAPI", targets: ["MediaAdminAPI"]),
        .library(name: "MediaAppAPI", targets: ["MediaAppAPI"]),
        .executable(name: "MediaAdminOpenAPIGenerator", targets: ["MediaAdminOpenAPIGenerator"]),
        .executable(name: "MediaAppOpenAPIGenerator", targets: ["MediaAppOpenAPIGenerator"]),
        .library(name: "MediaBackend", targets: ["MediaBackend"]),
        .library(name: "MediaFrontend", targets: ["MediaFrontend"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]

        .package(url: "https://github.com/feather-framework/feather-storage", exact: "1.0.0-beta.3"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.34.0"),
        .package(url: "https://github.com/swiftlang/swift-subprocess", from: "1.0.0"),
        .package(url: "https://github.com/mattpolzin/OpenAPIKit", from: "5.0.0"),
        .package(url: "https://github.com/jpsim/Yams", from: "6.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.12.1"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.27.0"),
        .package(url: "https://github.com/swift-server/async-http-client", from: "1.0.0"),
        .package(url: "https://github.com/feather-framework/feather-database-postgres", exact: "1.0.0-rc.2"),
        .package(url: "https://github.com/vapor/postgres-nio", from: "1.32.2"),
        .package(url: "https://github.com/apple/swift-nio-ssl", from: "2.34.0"),

        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
    ],
    targets: [
        .target(
            name: "MediaContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core"),
            ],
            path: "Sources/Contracts",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "MediaContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherStorage", package: "feather-storage"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "SystemApplication", package: "app-system-module"),

                .target(name: "MediaDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),

                .product(name: "FeatherStorage", package: "feather-storage"),
                .product(name: "Subprocess", package: "swift-subprocess"),

                .target(name: "MediaApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "MediaAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),

                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "MediaAppOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),

                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),

                .target(name: "MediaApplication"),
                .target(name: "MediaInfrastructure"),
                .target(name: "MediaAdminAPI"),
                .target(name: "MediaAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),
                .product(name: "SystemContracts", package: "app-system-module"),

                .target(name: "MediaContracts"),
                .target(name: "MediaAdminAPI"),
            ],
            path: "Sources/Composition/Frontend",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "MediaDomainTests",
            dependencies: [
                .target(name: "MediaDomain"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "MediaApplicationTests",
            dependencies: [
                .target(name: "MediaApplication"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "MediaInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDatabasePostgres", package: "feather-database-postgres"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),

                .target(name: "MediaInfrastructure"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
