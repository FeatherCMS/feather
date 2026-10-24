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
    name: "app-analytics-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "AnalyticsDomain", targets: ["AnalyticsDomain"]),
        .library(name: "AnalyticsModule", targets: ["AnalyticsModule"]),
        .library(
            name: "AnalyticsApplication",
            targets: ["AnalyticsApplication"]
        ),
        .library(
            name: "AnalyticsInfrastructure",
            targets: ["AnalyticsInfrastructure"]
        ),
        .library(name: "AnalyticsAdminAPI", targets: ["AnalyticsAdminAPI"]),
        .library(name: "AnalyticsAppAPI", targets: ["AnalyticsAppAPI"]),
        .executable(
            name: "AnalyticsAdminOpenAPIGenerator",
            targets: ["AnalyticsAdminOpenAPIGenerator"]
        ),
        .executable(
            name: "AnalyticsAppOpenAPIGenerator",
            targets: ["AnalyticsAppOpenAPIGenerator"]
        ),
        .library(name: "AnalyticsBackend", targets: ["AnalyticsBackend"]),
        .library(name: "AnalyticsWebShared", targets: ["AnalyticsWebShared"]),
        .library(name: "AnalyticsWebAdmin", targets: ["AnalyticsWebAdmin"]),
        .library(name: "AnalyticsWebApp", targets: ["AnalyticsWebApp"]),
    ],
    dependencies: [
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
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.27.0"
        ),
        .package(
            url:
                "https://github.com/hummingbird-project/swift-openapi-hummingbird",
            from: "2.0.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-http",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/apple/swift-http-types",
            from: "1.0.0"
        ),
        .package(
            url:
                "https://github.com/feather-framework/feather-http-hummingbird-testing",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/swift-server/async-http-client",
            from: "1.0.0"
        ),
        .package(
            url:
                "https://github.com/swift-server/swift-openapi-async-http-client",
            from: "1.0.0"
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
        .package(path: "../app-system-module"),
    ],
    targets: [
        .target(
            name: "AnalyticsModule",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core")
            ],
            path: "Sources/Module",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "AnalyticsModule"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "SystemModule", package: "app-system-module"),

                .target(name: "AnalyticsModule"),
                .target(name: "AnalyticsDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsInfrastructure",
            dependencies: [
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "SystemModule", package: "app-system-module"),

                .target(name: "AnalyticsModule"),
                .target(name: "AnalyticsApplication"),
                .target(name: "AnalyticsDomain"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsAdminAPI",
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
        .target(
            name: "AnalyticsAppAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                )
            ],
            path: "Sources/APIs/App",
            swiftSettings: sharedSwiftSettings + [
                // https://github.com/apple/swift-openapi-generator/issues/946
                .unsafeFlags(["-suppress-warnings"])
            ]
        ),
        .executableTarget(
            name: "AnalyticsAdminOpenAPIGenerator",
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
        .executableTarget(
            name: "AnalyticsAppOpenAPIGenerator",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),

                .target(name: "AnalyticsModule"),
                .target(name: "AnalyticsInfrastructure"),
                .target(name: "AnalyticsAdminAPI"),
                .target(name: "AnalyticsAppAPI"),
                .target(name: "AnalyticsDomain"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsWebShared",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/Composition/WebShared",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsWebAdmin",
            dependencies: [
                .target(name: "AnalyticsWebShared"),
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),

                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),
                .target(name: "AnalyticsModule"),
                .target(name: "AnalyticsApplication"),
                .target(name: "AnalyticsDomain"),
                .target(name: "AnalyticsAdminAPI"),
            ],
            path: "Sources/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsWebApp",
            dependencies: [
                .target(name: "AnalyticsWebShared"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "FeatherWebApp", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .target(name: "AnalyticsModule"),
                .target(name: "AnalyticsAppAPI"),
            ],
            path: "Sources/Composition/WebApp",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AnalyticsDomainTests",
            dependencies: [
                .target(name: "AnalyticsModule"),
                .target(name: "AnalyticsDomain"),
            ],
            path: "Tests/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AnalyticsApplicationTests",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "FeatherTesting", package: "feather-core"),
                .target(name: "AnalyticsDomain"),
                .target(name: "AnalyticsModule"),
                .target(name: "AnalyticsApplication"),
            ],
            path: "Tests/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AnalyticsInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .target(name: "AnalyticsInfrastructure"),
                .target(name: "AnalyticsModule"),
            ],
            path: "Tests/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AnalyticsBackendTests",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherHTTP", package: "feather-http"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
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

                .target(name: "AnalyticsBackend"),
                .target(name: "AnalyticsAdminAPI"),
                .target(name: "AnalyticsApplication"),
                .target(name: "AnalyticsDomain"),
                .target(name: "AnalyticsModule"),
            ],
            path: "Tests/Composition/Backend",
            swiftSettings: swiftSettings
        ),
    ]
)
