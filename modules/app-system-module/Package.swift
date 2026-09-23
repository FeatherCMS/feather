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
    name: "app-system-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "SystemDomain", targets: ["SystemDomain"]),
        .library(name: "SystemContracts", targets: ["SystemContracts"]),
        .library(name: "SystemApplication", targets: ["SystemApplication"]),
        .library(name: "SystemInfrastructure", targets: ["SystemInfrastructure"]),
        .library(name: "SystemAdminAPI", targets: ["SystemAdminAPI"]),
        .library(name: "SystemAppAPI", targets: ["SystemAppAPI"]),
        .library(name: "SystemBackend", targets: ["SystemBackend"]),
        .library(name: "SystemFrontend", targets: ["SystemFrontend"]),
        .executable(name: "SystemAdminOpenAPIGenerator", targets: ["SystemAdminOpenAPIGenerator"]),
        .executable(name: "SystemAppOpenAPIGenerator", targets: ["SystemAppOpenAPIGenerator"]),
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
        .package(path: "../../feather-core"),
    ],
    targets: [
        .target(
            name: "SystemContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "SystemDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "SystemContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "SystemApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),

                .target(name: "SystemDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "SystemInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),

                .target(name: "SystemApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "SystemAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "SystemAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .executableTarget(
            name: "SystemAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),

                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "SystemAppOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),

                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "SystemBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),

                .target(name: "SystemInfrastructure"),
                .target(name: "SystemAdminAPI"),
                .target(name: "SystemAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "SystemFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),

                .target(name: "SystemContracts"),
                .target(name: "SystemAdminAPI"),
                .target(name: "SystemAppAPI"),
            ],
            path: "Sources/Composition/Frontend",
            exclude: [
            ],
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .testTarget(
            name: "SystemDomainTests",
            dependencies: [
                .target(name: "SystemDomain")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SystemApplicationTests",
            dependencies: [
                .target(name: "SystemApplication")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SystemInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDatabasePostgres", package: "feather-database-postgres"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),

                .target(name: "SystemInfrastructure"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
