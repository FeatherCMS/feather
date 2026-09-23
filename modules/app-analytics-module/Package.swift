// swift-tools-version:6.3
import PackageDescription

var swiftSettings: [SwiftSetting] = [
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
        .library(name: "AnalyticsContracts", targets: ["AnalyticsContracts"]),
        .library(name: "AnalyticsApplication", targets: ["AnalyticsApplication"]),
        .library(name: "AnalyticsInfrastructure", targets: ["AnalyticsInfrastructure"]),
        .library(name: "AnalyticsAdminAPI", targets: ["AnalyticsAdminAPI"]),
        .library(name: "AnalyticsAppAPI", targets: ["AnalyticsAppAPI"]),
        .executable(name: "AnalyticsAdminOpenAPIGenerator", targets: ["AnalyticsAdminOpenAPIGenerator"]),
        .executable(name: "AnalyticsAppOpenAPIGenerator", targets: ["AnalyticsAppOpenAPIGenerator"]),
        .library(name: "AnalyticsBackend", targets: ["AnalyticsBackend"]),
        .library(name: "AnalyticsFrontend", targets: ["AnalyticsFrontend"]),
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
        .package(path: "../app-system-module"),
    ],
    targets: [
        .target(
            name: "AnalyticsContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "AnalyticsContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),

                .target(name: "AnalyticsDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),

                .target(name: "AnalyticsApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsSharedOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "AnalyticsAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "AnalyticsSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "AnalyticsAppOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "AnalyticsSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),

                .target(name: "AnalyticsInfrastructure"),
                .target(name: "AnalyticsAdminAPI"),
                .target(name: "AnalyticsAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AnalyticsFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),

                .product(name: "SystemContracts", package: "app-system-module"),
                .product(name: "SystemFrontend", package: "app-system-module"),
                .target(name: "AnalyticsContracts"),
                .target(name: "AnalyticsAdminAPI"),
                .target(name: "AnalyticsAppAPI"),
            ],
            path: "Sources/Composition/Frontend",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AnalyticsDomainTests",
            dependencies: [
                .target(name: "AnalyticsDomain"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AnalyticsApplicationTests",
            dependencies: [
                .target(name: "AnalyticsApplication"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AnalyticsInfrastructureTests",
            dependencies: [
                .target(name: "AnalyticsInfrastructure"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
