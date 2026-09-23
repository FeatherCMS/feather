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
    name: "app-blog-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "BlogDomain", targets: ["BlogDomain"]),
        .library(name: "BlogContracts", targets: ["BlogContracts"]),
        .library(name: "BlogApplication", targets: ["BlogApplication"]),
        .library(name: "BlogInfrastructure", targets: ["BlogInfrastructure"]),
        .library(name: "BlogAdminAPI", targets: ["BlogAdminAPI"]),
        .library(name: "BlogAppAPI", targets: ["BlogAppAPI"]),
        .library(
            name: "BlogSharedOpenAPIGenerator",
            targets: ["BlogSharedOpenAPIGenerator"]
        ),
        .executable(
            name: "BlogAdminOpenAPIGenerator",
            targets: ["BlogAdminOpenAPIGenerator"]
        ),
        .executable(
            name: "BlogAppOpenAPIGenerator",
            targets: ["BlogAppOpenAPIGenerator"]
        ),
        .library(name: "BlogBackend", targets: ["BlogBackend"]),
        .library(
            name: "BlogFrontend",
            targets: ["BlogFrontend"]
        ),
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
            from: "2.26.0"
        ),
        .package(
            url: "https://github.com/swift-server/async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-nio-ssl",
            from: "2.34.0"
        ),
        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
        .package(path: "../app-web-module"),
        .package(path: "../app-media-module"),

    ],
    targets: [
        .target(
            name: "BlogContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BlogDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "WebDomain", package: "app-web-module"),

                .target(name: "BlogContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BlogApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "WebApplication", package: "app-web-module"),

                .target(name: "BlogDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BlogInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),

                .target(name: "BlogApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "BlogAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BlogAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "BlogSharedOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "BlogAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "BlogSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "BlogAppOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "BlogSharedOpenAPIGenerator"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "BlogBackend",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),
                .product(name: "MediaBackend", package: "app-media-module"),

                .product(name: "WebAdminAPI", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),

                .target(name: "BlogInfrastructure"),
                .target(name: "BlogAdminAPI"),
                .target(name: "BlogAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BlogFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),

                .product(name: "SystemContracts", package: "app-system-module"),
                .product(name: "SystemFrontend", package: "app-system-module"),
                .product(name: "WebContracts", package: "app-web-module"),
                .product(name: "WebFrontend", package: "app-web-module"),
                .product(name: "MediaFrontend", package: "app-media-module"),

                .target(name: "BlogContracts"),
                .target(name: "BlogAdminAPI"),
                .target(name: "BlogAppAPI"),
            ],
            path: "Sources/Composition/Frontend",
            resources: [
                .copy("Resources/Templates")
            ],
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .testTarget(
            name: "BlogDomainTests",
            dependencies: [
                .target(name: "BlogDomain"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "BlogApplicationTests",
            dependencies: [
                .target(name: "BlogApplication"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "BlogInfrastructureTests",
            dependencies: [
                .target(name: "BlogInfrastructure"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
