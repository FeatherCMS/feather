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
    name: "app-web-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "WebDomain", targets: ["WebDomain"]),
        .library(name: "WebModule", targets: ["WebModule"]),
        .library(name: "WebApplication", targets: ["WebApplication"]),
        .library(name: "WebInfrastructure", targets: ["WebInfrastructure"]),
        .library(name: "WebAdminAPI", targets: ["WebAdminAPI"]),
        .library(name: "WebAppAPI", targets: ["WebAppAPI"]),
        .library(name: "WebBackend", targets: ["WebBackend"]),
        .library(name: "WebModuleWebApp", targets: ["WebModuleWebApp"]),
        .library(name: "WebModuleWebAdmin", targets: ["WebModuleWebAdmin"]),
        .executable(
            name: "WebAdminOpenAPIGenerator",
            targets: ["WebAdminOpenAPIGenerator"]
        ),
        .executable(
            name: "WebAppOpenAPIGenerator",
            targets: ["WebAppOpenAPIGenerator"]
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
            url:
                "https://github.com/feather-framework/feather-http-hummingbird-testing",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-http",
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
        .package(
            url: "https://github.com/hummingbird-project/swift-mustache",
            from: "2.1.1"
        ),
        .package(
            url: "https://github.com/apple/swift-markdown",
            from: "0.8.0"
        ),
        .package(
            url: "https://github.com/BinaryBirds/swift-web-standards",
            exact: "1.0.0-beta.4"
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
        .package(path: "../app-media-module"),
        .package(path: "../app-system-module"),
    ],
    targets: [
        .target(
            name: "WebModule",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core")
            ],
            path: "Sources/Module",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WebDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "WebModule"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WebApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .target(name: "WebModule"),

                .product(name: "SystemModule", package: "app-system-module"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),

                .target(name: "WebDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WebInfrastructure",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .target(name: "WebModule"),
                .product(name: "MediaDomain", package: "app-media-module"),
                .product(
                    name: "MediaInfrastructure",
                    package: "app-media-module"
                ),
                .product(
                    name: "SystemInfrastructure",
                    package: "app-system-module"
                ),

                .target(name: "WebDomain"),
                .target(name: "WebApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "WebAdminAPI",
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
            name: "WebAppAPI",
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
            name: "WebOpenAPIGeneratorSupport",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
                .product(name: "OpenAPIKit30", package: "OpenAPIKit"),
            ],
            path: "Sources/Generators/SchemaSupport",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "WebAdminOpenAPIGenerator",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "WebOpenAPIGeneratorSupport"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "WebAppOpenAPIGenerator",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),

                .target(name: "WebOpenAPIGeneratorSupport"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "WebBackend",
            dependencies: [
                .target(name: "WebModule"),
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "MediaBackend", package: "app-media-module"),
                .product(
                    name: "MediaApplication",
                    package: "app-media-module"
                ),
                .product(
                    name: "SystemInfrastructure",
                    package: "app-system-module"
                ),

                .target(name: "WebDomain"),
                .target(name: "WebApplication"),
                .target(name: "WebInfrastructure"),
                .target(name: "WebAdminAPI"),
                .target(name: "WebAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WebModuleWebShared",
            dependencies: [
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(
                    name: "OpenAPIAsyncHTTPClient",
                    package: "swift-openapi-async-http-client"
                ),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
            ],
            path: "Sources/Composition/WebShared",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WebModuleWebApp",
            dependencies: [
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "FeatherWebApp", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "Markdown", package: "swift-markdown"),
                .product(name: "Mustache", package: "swift-mustache"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "RSS", package: "swift-web-standards"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "Sitemap", package: "swift-web-standards"),
                .product(name: "WebComponents", package: "swift-web-standards"),
                .product(name: "WebBuilders", package: "swift-web-standards"),

                .target(name: "WebModule"),
                .target(name: "WebDomain"),
                .target(name: "WebModuleWebShared"),
                .target(name: "WebAppAPI"),
            ],
            path: "Sources/Composition/WebApp",
            resources: [
                .copy("Resources/Templates")
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WebModuleWebAdmin",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "WebBuilders", package: "swift-web-standards"),
                .product(name: "WebComponents", package: "swift-web-standards"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "MediaModule", package: "app-media-module"),

                .target(name: "WebModule"),
                .target(name: "WebDomain"),
                .target(name: "WebModuleWebShared"),
                .target(name: "WebAdminAPI"),
                .product(name: "SystemAdminAPI", package: "app-system-module"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),
                .product(name: "MediaWebAdmin", package: "app-media-module"),
            ],
            path: "Sources/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .testTarget(
            name: "WebDomainTests",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .target(name: "WebDomain"),
                .target(name: "WebModule"),
            ],
            path: "Tests/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "WebApplicationTests",
            dependencies: [
                .product(name: "FeatherTesting", package: "feather-core"),
                .target(name: "WebApplication"),
                .target(name: "WebDomain"),
                .target(name: "WebModule"),
            ],
            path: "Tests/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "WebModuleWebAppTests",
            dependencies: [
                .target(name: "WebModuleWebApp"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "WebComponents", package: "swift-web-standards"),
            ],
            path: "Tests/Composition/WebApp",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "WebModuleWebAdminTests",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .target(name: "WebDomain"),
                .target(name: "WebModule"),
                .target(name: "WebModuleWebAdmin"),
            ],
            path: "Tests/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "WebBackendTests",
            dependencies: [
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
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(
                    name: "FeatherDatabaseTesting",
                    package: "feather-database"
                ),
                .target(name: "WebBackend"),
                .target(name: "WebAdminAPI"),
                .target(name: "WebApplication"),
                .target(name: "WebDomain"),
                .target(name: "WebModule"),
            ],
            path: "Tests/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "WebInfrastructureTests",
            dependencies: [
                .target(name: "WebInfrastructure"),
                .target(name: "WebApplication"),
                .target(name: "WebModule"),
                .target(name: "WebDomain"),

                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(
                    name: "FeatherDatabaseTesting",
                    package: "feather-database"
                ),
                .product(name: "FeatherTesting", package: "feather-core"),
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "SystemModule", package: "app-system-module"),
            ],
            path: "Tests/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
    ]
)
