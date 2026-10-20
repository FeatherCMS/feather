// swift-tools-version:6.3
import PackageDescription

let sharedSwiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .strictMemorySafety(),
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

let swiftSettings =
    sharedSwiftSettings + [
        .treatAllWarnings(as: .error)
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
        .library(name: "SystemModule", targets: ["SystemModule"]),
        .library(name: "SystemDomain", targets: ["SystemDomain"]),
        .library(name: "SystemApplication", targets: ["SystemApplication"]),
        .library(
            name: "SystemInfrastructure",
            targets: ["SystemInfrastructure"]
        ),
        .library(name: "SystemAdminAPI", targets: ["SystemAdminAPI"]),
        .library(name: "SystemBackend", targets: ["SystemBackend"]),
        .library(
            name: "SystemModuleWebAdmin",
            targets: ["SystemModuleWebAdmin"]
        ),
        .executable(
            name: "SystemAdminOpenAPIGenerator",
            targets: ["SystemAdminOpenAPIGenerator"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.15.0"
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
            from: "1.13.2"
        ),
        .package(
            url: "https://github.com/apple/swift-nio",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.27.0"
        ),
        .package(
            url:
                "https://github.com/hummingbird-project/swift-openapi-hummingbird",
            from: "2.0.1"
        ),
        .package(
            url: "https://github.com/swift-server/async-http-client",
            from: "1.0.0"
        ),
        .package(
            url:
                "https://github.com/feather-framework/feather-http-hummingbird-testing",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-http",
            exact: "1.0.0-beta.1"
        ),
        .package(path: "../../feather-core"),
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.3"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-dbal",
            exact: "1.0.0-alpha.1"
        ),
    ],
    targets: [
        .target(
            name: "SystemModule",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core")
            ],
            path: "Sources/Module",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "SystemDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "SystemModule"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "SystemApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "SystemDomain"),
                .target(name: "SystemModule"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "SystemInfrastructure",
            dependencies: [
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "FeatherDatabase", package: "feather-database"),

                .target(name: "SystemApplication"),
                .target(name: "SystemModule"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "SystemAdminAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                )
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: sharedSwiftSettings + [
                // https://github.com/apple/swift-openapi-generator/issues/946
                .unsafeFlags(["-suppress-warnings"])
            ]
        ),
        // MARK: -
        .executableTarget(
            name: "SystemAdminOpenAPIGenerator",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),

                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "SystemBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .target(name: "SystemApplication"),
                .target(name: "SystemDomain"),
                .target(name: "SystemInfrastructure"),
                .target(name: "SystemAdminAPI"),
                .target(name: "SystemModule"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "SystemModuleWebAdmin",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),

                .target(name: "SystemModule"),
                .target(name: "SystemAdminAPI"),
            ],
            path: "Sources/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .testTarget(
            name: "SystemDomainTests",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .target(name: "SystemDomain"),
            ],
            path: "Tests/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SystemApplicationTests",
            dependencies: [
                .product(name: "FeatherTesting", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .target(name: "SystemApplication"),
            ],
            path: "Tests/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SystemInfrastructureTests",
            dependencies: [
                .product(name: "FeatherTesting", package: "feather-core"),
                .product(
                    name: "FeatherDatabaseTesting",
                    package: "feather-database"
                ),
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "FeatherDBAL", package: "feather-dbal"),

                .target(name: "SystemInfrastructure"),
                .target(name: "SystemApplication"),
                .target(name: "SystemDomain"),
            ],
            path: "Tests/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SystemBackendTests",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "FeatherHTTP", package: "feather-http"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(name: "FeatherTesting", package: "feather-core"),
                .product(
                    name: "FeatherHTTPHummingbirdTesting",
                    package: "feather-http-hummingbird-testing"
                ),
                .product(
                    name: "OpenAPIHummingbird",
                    package: "swift-openapi-hummingbird"
                ),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(
                    name: "FeatherDatabaseTesting",
                    package: "feather-database"
                ),
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(name: "Hummingbird", package: "hummingbird"),

                .target(name: "SystemBackend"),
                .target(name: "SystemAdminAPI"),
                .target(name: "SystemApplication"),
                .target(name: "SystemDomain"),
                .target(name: "SystemModule"),
            ],
            path: "Tests/Composition/Backend",
            swiftSettings: swiftSettings
        ),
    ]
)
