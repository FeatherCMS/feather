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
    name: "app-auth-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "AuthDomain", targets: ["AuthDomain"]),
        .library(name: "AuthContracts", targets: ["AuthContracts"]),
        .library(name: "AuthApplication", targets: ["AuthApplication"]),
        .library(name: "AuthInfrastructure", targets: ["AuthInfrastructure"]),
        .library(name: "AuthBackend", targets: ["AuthBackend"]),
        .library(name: "AuthFrontend", targets: ["AuthFrontend"]),
        .library(name: "AuthAdminAPI", targets: ["AuthAdminAPI"]),
        .library(name: "AuthAppAPI", targets: ["AuthAppAPI"]),
        .library(name: "AuthSharedOpenAPIGenerator", targets: ["AuthSharedOpenAPIGenerator"]),
        .executable(name: "AuthAdminOpenAPIGenerator", targets: ["AuthAdminOpenAPIGenerator"]),
        .executable(name: "AuthAppOpenAPIGenerator", targets: ["AuthAppOpenAPIGenerator"]),
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
        .package(
            url:
                "https://github.com/feather-framework/feather-database-postgres",
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
        .package(path: "../app-media-module"),
        .package(path: "../app-system-module"),
        .package(path: "../app-user-module"),
        .package(path: "../app-web-module"),
    ],
    targets: [
        .target(
            name: "AuthContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "AuthContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),

                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "UserApplication", package: "app-user-module"),
                .product(name: "WebApplication", package: "app-web-module"),

                .target(name: "AuthDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),

                .product(name: "UserInfrastructure", package: "app-user-module"),

                .target(name: "AuthApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthSharedOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "UserSharedOpenAPIGenerator", package: "app-user-module"),
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "AuthAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "AuthSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "AuthAppOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "AuthSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),

                .product(name: "SystemAdminAPI", package: "app-system-module"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),
                .product(name: "UserBackend", package: "app-user-module"),

                .target(name: "AuthInfrastructure"),
                .target(name: "AuthAdminAPI"),
                .target(name: "AuthAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),

                .product(name: "MediaFrontend", package: "app-media-module"),
                .product(name: "UserFrontend", package: "app-user-module"),
                .product(name: "SystemFrontend", package: "app-system-module"),
                .product(name: "WebContracts", package: "app-web-module"),

                .target(name: "AuthContracts"),
                .target(name: "AuthAdminAPI"),
                .target(name: "AuthAppAPI"),
            ],
            path: "Sources/Composition/Frontend",
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AuthDomainTests",
            dependencies: [
                .target(name: "AuthDomain"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AuthApplicationTests",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "UserDomain", package: "app-user-module"),

                .target(name: "AuthApplication"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AuthInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDatabasePostgres", package: "feather-database-postgres"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),

                .product(name: "SystemInfrastructure", package: "app-system-module"),
                .product(name: "UserInfrastructure", package: "app-user-module"),

                .target(name: "AuthInfrastructure"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
