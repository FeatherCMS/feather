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
    name: "app-news-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "NewsDomain", targets: ["NewsDomain"]),
        .library(name: "NewsModule", targets: ["NewsModule"]),
        .library(name: "NewsApplication", targets: ["NewsApplication"]),
        .library(name: "NewsInfrastructure", targets: ["NewsInfrastructure"]),
        .library(name: "NewsAdminAPI", targets: ["NewsAdminAPI"]),
        .library(name: "NewsAppAPI", targets: ["NewsAppAPI"]),
        .library(
            name: "NewsOpenAPIGeneratorSupport",
            targets: ["NewsOpenAPIGeneratorSupport"]
        ),
        .executable(
            name: "NewsAdminOpenAPIGenerator",
            targets: ["NewsAdminOpenAPIGenerator"]
        ),
        .executable(
            name: "NewsAppOpenAPIGenerator",
            targets: ["NewsAppOpenAPIGenerator"]
        ),
        .library(name: "NewsBackend", targets: ["NewsBackend"]),
        .library(name: "NewsWebAdmin", targets: ["NewsWebAdmin"]),
        .library(name: "NewsWebApp", targets: ["NewsWebApp"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.0.0"
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
            url:
                "https://github.com/feather-framework/feather-http-hummingbird-testing",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/apple/swift-http-types",
            from: "1.0.0"
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
            url: "https://github.com/apple/swift-nio",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-nio-ssl",
            from: "2.34.0"
        ),
        .package(
            url: "https://github.com/BinaryBirds/swift-web-standards",
            exact: "1.0.0-beta.4"
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
        .package(path: "../app-web-module"),
        .package(path: "../app-media-module"),
    ],
    targets: [
        .target(
            name: "NewsModule",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core")
            ],
            path: "Sources/Module",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "WebModule", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),

                .target(name: "NewsModule"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "WebModule", package: "app-web-module"),
                .product(name: "WebApplication", package: "app-web-module"),

                .target(name: "NewsModule"),
                .target(name: "NewsDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsInfrastructure",
            dependencies: [
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "MediaDomain", package: "app-media-module"),
                .product(
                    name: "MediaInfrastructure",
                    package: "app-media-module"
                ),
                .product(name: "MediaModule", package: "app-media-module"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "WebModule", package: "app-web-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),

                .target(name: "NewsModule"),
                .target(name: "NewsApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "NewsAppAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                )
            ],
            path: "Sources/APIs/App",
            swiftSettings: sharedSwiftSettings + [
                .unsafeFlags(["-suppress-warnings"])
            ]
        ),
        .target(
            name: "NewsAdminAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                )
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: sharedSwiftSettings + [
                .unsafeFlags(["-suppress-warnings"])
            ]
        ),
        // MARK: -
        .executableTarget(
            name: "NewsAdminOpenAPIGenerator",
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
            name: "NewsAppOpenAPIGenerator",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
                .product(name: "OpenAPIKit30", package: "OpenAPIKit"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
                .target(name: "NewsOpenAPIGeneratorSupport"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsOpenAPIGeneratorSupport",
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
        // MARK: -
        .target(
            name: "NewsBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebModule", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(
                    name: "SystemInfrastructure",
                    package: "app-system-module"
                ),
                .target(name: "NewsModule"),
                .target(name: "NewsDomain"),

                .target(name: "NewsApplication"),
                .target(name: "NewsInfrastructure"),
                .target(name: "NewsAdminAPI"),
                .target(name: "NewsAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsWebAdmin",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),

                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "MediaWebAdmin", package: "app-media-module"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),
                .product(name: "WebModule", package: "app-web-module"),
                .product(name: "WebModuleWebApp", package: "app-web-module"),
                .product(name: "WebModuleWebAdmin", package: "app-web-module"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(
                    name: "OpenAPIAsyncHTTPClient",
                    package: "swift-openapi-async-http-client"
                ),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "WebBuilders", package: "swift-web-standards"),
                .product(name: "WebComponents", package: "swift-web-standards"),
                .target(name: "NewsModule"),
                .target(name: "NewsApplication"),
                .target(name: "NewsAdminAPI"),
            ],
            path: "Sources/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsWebApp",
            dependencies: [
                .product(name: "FeatherWebApp", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(
                    name: "OpenAPIAsyncHTTPClient",
                    package: "swift-openapi-async-http-client"
                ),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .product(name: "WebModule", package: "app-web-module"),
                .target(name: "NewsAppAPI"),
            ],
            path: "Sources/Composition/WebApp",
            resources: [
                .copy("Resources/Templates")
            ],
            swiftSettings: swiftSettings
        ),
        // MARK: - tests
        .testTarget(
            name: "NewsDomainTests",
            dependencies: [
                .target(name: "NewsDomain"),
                .target(name: "NewsModule"),
            ],
            path: "Tests/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "NewsApplicationTests",
            dependencies: [
                .product(
                    name: "FeatherApplication",
                    package: "feather-core"
                ),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "FeatherTesting", package: "feather-core"),
                .target(name: "NewsApplication"),
                .target(name: "NewsDomain"),
                .target(name: "NewsModule"),
            ],
            path: "Tests/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "NewsWebAdminTests",
            dependencies: [
                .product(
                    name: "FeatherWebShared",
                    package: "feather-core"
                ),
                .target(name: "NewsWebAdmin"),
                .product(name: "Hummingbird", package: "hummingbird"),
            ],
            path: "Tests/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "NewsInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .target(name: "NewsInfrastructure"),
                .target(name: "NewsModule"),
            ],
            path: "Tests/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "NewsBackendTests",
            dependencies: [
                .product(name: "FeatherHTTP", package: "feather-http"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(
                    name: "FeatherModuleKit",
                    package: "feather-core"
                ),
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

                .target(name: "NewsBackend"),
                .target(name: "NewsAdminAPI"),
                .target(name: "NewsApplication"),
                .target(name: "NewsDomain"),
                .target(name: "NewsInfrastructure"),
                .target(name: "NewsModule"),
            ],
            path: "Tests/Composition/Backend",
            swiftSettings: swiftSettings
        ),
    ]
)
