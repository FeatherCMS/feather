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

let swiftSettings = sharedSwiftSettings + [.treatAllWarnings(as: .error)]

let package = Package(
    name: "app-redirect-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "RedirectModule", targets: ["RedirectModule"]),
        .library(name: "RedirectDomain", targets: ["RedirectDomain"]),
        .library(name: "RedirectApplication", targets: ["RedirectApplication"]),
        .library(
            name: "RedirectInfrastructure",
            targets: ["RedirectInfrastructure"]
        ),
        .library(name: "RedirectBackend", targets: ["RedirectBackend"]),
        .library(name: "RedirectAdminAPI", targets: ["RedirectAdminAPI"]),
        .library(name: "RedirectAppAPI", targets: ["RedirectAppAPI"]),
        .executable(
            name: "RedirectAdminOpenAPIGenerator",
            targets: ["RedirectAdminOpenAPIGenerator"]
        ),
        .executable(
            name: "RedirectAppOpenAPIGenerator",
            targets: ["RedirectAppOpenAPIGenerator"]
        ),
        .library(name: "RedirectWebAdmin", targets: ["RedirectWebAdmin"]),
        .library(name: "RedirectWebShared", targets: ["RedirectWebShared"]),
        .library(name: "RedirectWebApp", targets: ["RedirectWebApp"]),
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
            url: "https://github.com/apple/swift-http-types",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.3"
        ),
        .package(path: "../../feather-core"),
        .package(
            url: "https://github.com/feather-framework/feather-dbal",
            exact: "1.0.0-alpha.1"
        ),
        .package(path: "../app-system-module"),
    ],
    targets: [
        .target(
            name: "RedirectModule",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core")
            ],
            path: "Sources/Module",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "RedirectModule"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),

                .target(name: "RedirectModule"),
                .target(name: "RedirectDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectInfrastructure",
            dependencies: [
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "SystemModule", package: "app-system-module"),

                .target(name: "RedirectModule"),
                .target(name: "RedirectDomain"),
                .target(name: "RedirectApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectAdminAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                )
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectAppAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                )
            ],
            path: "Sources/APIs/App",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "RedirectAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "RedirectAppOpenAPIGenerator",
            dependencies: [
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "NIOHTTP1", package: "swift-nio"),

                .target(name: "RedirectInfrastructure"),
                .target(name: "RedirectApplication"),
                .target(name: "RedirectDomain"),
                .target(name: "RedirectModule"),
                .target(name: "RedirectAdminAPI"),
                .target(name: "RedirectAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectWebShared",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/Composition/WebShared",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectWebApp",
            dependencies: [
                .target(name: "RedirectWebShared"),
                .product(name: "FeatherWebApp", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "Logging", package: "swift-log"),

                .target(name: "RedirectAppAPI"),
            ],
            path: "Sources/Composition/WebApp",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "RedirectWebAdmin",
            dependencies: [
                .target(name: "RedirectWebShared"),
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),

                .target(name: "RedirectModule"),
                .target(name: "RedirectDomain"),
                .target(name: "RedirectApplication"),
                .target(name: "RedirectAdminAPI"),
            ],
            path: "Sources/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),

        .testTarget(
            name: "RedirectDomainTests",
            dependencies: [
                .target(name: "RedirectModule"),
                .target(name: "RedirectDomain"),
            ],
            path: "Tests/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "RedirectApplicationTests",
            dependencies: [
                .product(name: "FeatherTesting", package: "feather-core"),
                .target(name: "RedirectApplication"),
                .target(name: "RedirectModule"),
            ],
            path: "Tests/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "RedirectInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(
                    name: "FeatherDatabaseTesting",
                    package: "feather-database"
                ),
                .target(name: "RedirectInfrastructure"),
                .target(name: "RedirectModule"),
            ],
            path: "Tests/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "RedirectBackendTests",
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
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(
                    name: "FeatherDatabaseTesting",
                    package: "feather-database"
                ),
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .target(name: "RedirectBackend"),
                .target(name: "RedirectAdminAPI"),
                .target(name: "RedirectAppAPI"),
                .target(name: "RedirectApplication"),
                .target(name: "RedirectDomain"),
                .target(name: "RedirectModule"),
            ],
            path: "Tests/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "RedirectWebAppTests",
            dependencies: [
                .product(name: "FeatherHTTP", package: "feather-http"),
                .product(
                    name: "FeatherHTTPHummingbirdTesting",
                    package: "feather-http-hummingbird-testing"
                ),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .target(name: "RedirectAppAPI"),
                .target(name: "RedirectWebApp"),
            ],
            path: "Tests/Composition/WebApp",
            swiftSettings: swiftSettings
        ),
    ]
)
