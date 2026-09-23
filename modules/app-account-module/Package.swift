// swift-tools-version:6.3
import PackageDescription

var defaultSwiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .strictMemorySafety(),
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
    name: "app-account-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "AccountDomain", targets: ["AccountDomain"]),
        .library(name: "AccountContracts", targets: ["AccountContracts"]),
        .library(name: "AccountApplication", targets: ["AccountApplication"]),
        .library(name: "AccountInfrastructure", targets: ["AccountInfrastructure"]),
        .library(name: "AccountAdminAPI", targets: ["AccountAdminAPI"]),
        .library(name: "AccountAppAPI", targets: ["AccountAppAPI"]),
        .library(name: "AccountSharedOpenAPIGenerator", targets: ["AccountSharedOpenAPIGenerator"]),
        .library(name: "AccountBackend", targets: ["AccountBackend"]),
        .library(name: "AccountFrontend", targets: ["AccountFrontend"]),
        .executable(name: "AccountAdminOpenAPIGenerator", targets: ["AccountAdminOpenAPIGenerator"]),
        .executable(name: "AccountAppOpenAPIGenerator", targets: ["AccountAppOpenAPIGenerator"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]

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
            from: "1.9.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.27.0"
        ),
        .package(
            url: "https://github.com/swift-server/async-http-client",
            from: "1.0.0"
        ),

        .package(path: "../../feather-core"),
        .package(path: "../app-auth-module"),
        .package(path: "../app-media-module"),
        .package(path: "../app-system-module"),
        .package(path: "../app-user-module"),

        // MARK: - test dependencies

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
    ],
    targets: [
        .target(
            name: "AccountContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "AccountContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),

                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "UserApplication", package: "app-user-module"),

                .target(name: "AccountDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),

                .target(name: "AccountApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountSharedOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),

                .product(name: "UserSharedOpenAPIGenerator", package: "app-user-module"),
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "AccountAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "AccountSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "AccountAppOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "AccountSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),

                .product(name: "AuthDomain", package: "app-auth-module"),
                .product(name: "AuthInfrastructure", package: "app-auth-module"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "UserInfrastructure", package: "app-user-module"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),

                .target(name: "AccountInfrastructure"),
                .target(name: "AccountAdminAPI"),
                .target(name: "AccountAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),

                .product(name: "AuthAdminAPI", package: "app-auth-module"),
                .product(name: "AuthAppAPI", package: "app-auth-module"),
                .product(name: "MediaFrontend", package: "app-media-module"),
                .product(name: "SystemAdminAPI", package: "app-system-module"),
                .product(name: "SystemContracts", package: "app-system-module"),
                .product(name: "SystemFrontend", package: "app-system-module"),
                .product(name: "UserAdminAPI", package: "app-user-module"),
                .product(name: "UserContracts", package: "app-user-module"),
                .product(name: "UserAppAPI", package: "app-user-module"),
                .product(name: "UserFrontend", package: "app-user-module"),

                .target(name: "AccountContracts"),
                .target(name: "AccountAdminAPI"),
                .target(name: "AccountAppAPI"),
            ],
            path: "Sources/Composition/Frontend",
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AccountDomainTests",
            dependencies: [
                .target(name: "AccountDomain"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AccountApplicationTests",
            dependencies: [
                .target(name: "AccountApplication"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AccountInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDatabasePostgres", package: "feather-database-postgres"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),

                .target(name: "AccountInfrastructure"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
