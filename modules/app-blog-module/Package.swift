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
    name: "app-blog-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "BlogModule", targets: ["BlogModule"]),
        .library(name: "BlogDomain", targets: ["BlogDomain"]),
        .library(name: "BlogApplication", targets: ["BlogApplication"]),
        .library(name: "BlogInfrastructure", targets: ["BlogInfrastructure"]),
        .library(name: "BlogAdminAPI", targets: ["BlogAdminAPI"]),
        .library(name: "BlogAppAPI", targets: ["BlogAppAPI"]),
        .executable(
            name: "BlogAdminOpenAPIGenerator",
            targets: ["BlogAdminOpenAPIGenerator"]
        ),
        .executable(
            name: "BlogAppOpenAPIGenerator",
            targets: ["BlogAppOpenAPIGenerator"]
        ),
        .library(name: "BlogBackend", targets: ["BlogBackend"]),
        .library(name: "BlogWebApp", targets: ["BlogWebApp"]),
        .library(name: "BlogWebAdmin", targets: ["BlogWebAdmin"]),
        .library(name: "BlogWebShared", targets: ["BlogWebShared"]),
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
            from: "2.26.0"
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
                "https://github.com/swift-server/swift-openapi-async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/BinaryBirds/swift-web-standards",
            exact: "1.0.0-beta.4"
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
        .package(
            url: "https://github.com/feather-framework/feather-storage",
            exact: "1.0.0-rc.2"
        ),
        .package(path: "../../feather-core"),
        .package(
            url: "https://github.com/feather-framework/feather-dbal",
            exact: "1.0.0-alpha.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.3"
        ),
        .package(path: "../app-system-module"),
        .package(path: "../app-web-module"),
        .package(path: "../app-media-module"),

    ],
    targets: [
        .target(
            name: "BlogModule",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core")
            ],
            path: "Sources/Module",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BlogDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "WebDomain", package: "app-web-module"),

                .target(name: "BlogModule"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BlogApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),

                .target(name: "BlogModule"),
                .target(name: "BlogDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BlogInfrastructure",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "MediaDomain", package: "app-media-module"),
                .product(name: "MediaModule", package: "app-media-module"),
                .product(
                    name: "MediaInfrastructure",
                    package: "app-media-module"
                ),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "WebModule", package: "app-web-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),

                .target(name: "BlogApplication"),
                .target(name: "BlogModule"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "BlogAdminAPI",
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
            name: "BlogAppAPI",
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
        // MARK: -
        .target(
            name: "BlogSharedOpenAPIGenerator",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                )
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "BlogAdminOpenAPIGenerator",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
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
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
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
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(
                    name: "SystemInfrastructure",
                    package: "app-system-module"
                ),
                .product(name: "MediaBackend", package: "app-media-module"),

                .product(name: "WebAdminAPI", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),
                .product(
                    name: "WebInfrastructure",
                    package: "app-web-module"
                ),

                .target(name: "BlogInfrastructure"),
                .target(name: "BlogModule"),
                .target(name: "BlogApplication"),
                .target(name: "BlogDomain"),
                .target(name: "BlogAdminAPI"),
                .target(name: "BlogAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BlogWebShared",
            dependencies: [
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
            ],
            path: "Sources/Composition/WebShared",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BlogWebApp",
            dependencies: [
                .product(name: "FeatherWebApp", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(
                    name: "OpenAPIAsyncHTTPClient",
                    package: "swift-openapi-async-http-client"
                ),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .product(name: "WebModule", package: "app-web-module"),
                .product(name: "WebModuleWebApp", package: "app-web-module"),
                .product(name: "WebBuilders", package: "swift-web-standards"),
                .target(name: "BlogWebShared"),
                .target(name: "BlogApplication"),
                .target(name: "BlogAppAPI"),
            ],
            path: "Sources/Composition/WebApp",
            resources: [
                .copy("Resources/Templates")
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BlogWebAdmin",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(
                    name: "OpenAPIAsyncHTTPClient",
                    package: "swift-openapi-async-http-client"
                ),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .target(name: "BlogAppAPI"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),
                .product(name: "WebModule", package: "app-web-module"),
                .product(name: "WebModuleWebAdmin", package: "app-web-module"),
                .product(name: "MediaWebAdmin", package: "app-media-module"),
                .product(name: "MediaModule", package: "app-media-module"),
                .target(name: "BlogWebShared"),
                .target(name: "BlogModule"),
                .target(name: "BlogAdminAPI"),
            ],
            path: "Sources/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .testTarget(
            name: "BlogDomainTests",
            dependencies: [
                .target(name: "BlogDomain")
            ],
            path: "Tests/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "BlogApplicationTests",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherTesting", package: "feather-core"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),
                .target(name: "BlogApplication"),
                .target(name: "BlogDomain"),
            ],
            path: "Tests/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "BlogInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(
                    name: "FeatherDatabaseTesting",
                    package: "feather-database"
                ),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "FeatherTesting", package: "feather-core"),
                .target(name: "BlogInfrastructure"),
                .target(name: "BlogModule"),
            ],
            path: "Tests/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "BlogBackendTests",
            dependencies: [
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(
                    name: "FeatherDatabaseTesting",
                    package: "feather-database"
                ),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherHTTP", package: "feather-http"),
                .product(
                    name: "FeatherHTTPHummingbirdTesting",
                    package: "feather-http-hummingbird-testing"
                ),
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "FeatherStorage", package: "feather-storage"),
                .product(name: "FeatherTesting", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(
                    name: "HummingbirdTesting",
                    package: "hummingbird"
                ),
                .product(name: "MediaApplication", package: "app-media-module"),
                .product(name: "MediaBackend", package: "app-media-module"),
                .product(name: "MediaModule", package: "app-media-module"),
                .product(
                    name: "OpenAPIHummingbird",
                    package: "swift-openapi-hummingbird"
                ),
                .target(name: "BlogAdminAPI"),
                .target(name: "BlogAppAPI"),
                .target(name: "BlogBackend"),
            ],
            path: "Tests/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "BlogWebAdminTests",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .target(name: "BlogWebAdmin"),
            ],
            path: "Tests/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "BlogWebAppTests",
            dependencies: [
                .product(name: "WebModule", package: "app-web-module"),
                .target(name: "BlogWebApp"),
            ],
            path: "Tests/Composition/WebApp",
            swiftSettings: swiftSettings
        ),
    ]
)
