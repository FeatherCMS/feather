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
        .library(name: "AuthModule", targets: ["AuthModule"]),
        .library(name: "AuthApplication", targets: ["AuthApplication"]),
        .library(name: "AuthInfrastructure", targets: ["AuthInfrastructure"]),
        .library(name: "AuthBackend", targets: ["AuthBackend"]),
        .library(name: "AuthWebShared", targets: ["AuthWebShared"]),
        .library(name: "AuthWebApp", targets: ["AuthWebApp"]),
        .library(name: "AuthWebAdmin", targets: ["AuthWebAdmin"]),
        .library(name: "AuthAdminAPI", targets: ["AuthAdminAPI"]),
        .library(name: "AuthAppAPI", targets: ["AuthAppAPI"]),
        .executable(name: "AuthAdminOpenAPIGenerator", targets: ["AuthAdminOpenAPIGenerator"]),
        .executable(name: "AuthAppOpenAPIGenerator", targets: ["AuthAppOpenAPIGenerator"]),
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
            url: "https://github.com/swift-server/swift-openapi-async-http-client",
            from: "1.5.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.27.0"
        ),
        .package(
            url: "https://github.com/apple/swift-nio",
            from: "2.101.3"
        ),
        .package(
            url: "https://github.com/swift-server/async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-openapi-hummingbird",
            from: "2.0.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-http-hummingbird-testing",
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
        .package(
            url: "https://github.com/feather-framework/feather-mail",
            exact: "1.0.0-rc.1"
        ),
        .package(path: "../app-media-module"),
        .package(path: "../app-system-module"),
        .package(path: "../app-user-module"),
    ],
    targets: [
        .target(
            name: "AuthModule",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core")
            ],
            path: "Sources/Module",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AuthDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .target(name: "AuthModule"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AuthApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherMail", package: "feather-mail"),

                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "UserApplication", package: "app-user-module"),
                .product(name: "UserDomain", package: "app-user-module"),
                .product(name: "UserModule", package: "app-user-module"),

                .target(name: "AuthDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AuthInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemDomain", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),

                .product(name: "UserApplication", package: "app-user-module"),
                .product(name: "UserModule", package: "app-user-module"),
                .product(name: "UserInfrastructure", package: "app-user-module"),

                .target(name: "AuthApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AuthAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: sharedSwiftSettings + [
                // https://github.com/apple/swift-openapi-generator/issues/946
                .unsafeFlags(["-suppress-warnings"])
            ]
        ),
        .target(
            name: "AuthAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: sharedSwiftSettings + [
                // https://github.com/apple/swift-openapi-generator/issues/946
                .unsafeFlags(["-suppress-warnings"])
            ]
        ),
        .executableTarget(
            name: "AuthAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
                .product(name: "UserOpenAPIGeneratorSupport", package: "app-user-module"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "AuthAppOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
                .product(name: "UserOpenAPIGeneratorSupport", package: "app-user-module"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AuthBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "NIOHTTP1", package: "swift-nio"),

                .product(name: "SystemInfrastructure", package: "app-system-module"),
                .product(name: "UserModule", package: "app-user-module"),

                .target(name: "AuthModule"),
                .target(name: "AuthInfrastructure"),
                .target(name: "AuthApplication"),
                .target(name: "AuthAdminAPI"),
                .target(name: "AuthAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AuthWebShared",
            dependencies: [
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(
                    name: "OpenAPIAsyncHTTPClient",
                    package: "swift-openapi-async-http-client"
                ),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
            ],
            path: "Sources/Composition/WebShared",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AuthWebApp",
            dependencies: [
                .product(name: "FeatherWebApp", package: "feather-core"),
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),

                .target(name: "AuthModule"),
                .target(name: "AuthAppAPI"),
                .target(name: "AuthWebShared"),
            ],
            path: "Sources/Composition/WebApp",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AuthWebAdmin",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),

                .product(name: "UserWebAdmin", package: "app-user-module"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),

                .target(name: "AuthModule"),
                .target(name: "AuthAdminAPI"),
                .target(name: "AuthWebShared"),
            ],
            path: "Sources/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AuthDomainTests",
            dependencies: [
                .target(name: "AuthModule"),
                .target(name: "AuthDomain"),
            ],
            path: "Tests/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AuthApplicationTests",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .target(name: "AuthModule"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "UserDomain", package: "app-user-module"),
                .product(name: "UserModule", package: "app-user-module"),

                .target(name: "AuthApplication"),
            ],
            path: "Tests/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AuthInfrastructureTests",
            dependencies: [
                .product(name: "FeatherTesting", package: "feather-core"),
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "FeatherDatabaseTesting", package: "feather-database"),
                .product(name: "FeatherInfrastructure", package: "feather-core"),

                .target(name: "AuthApplication"),
                .target(name: "AuthModule"),
                .target(name: "AuthInfrastructure"),
            ],
            path: "Tests/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AuthBackendTests",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherHTTP", package: "feather-http"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "FeatherInfrastructure", package: "feather-core"),
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
                .target(name: "AuthBackend"),
                .target(name: "AuthAdminAPI"),
                .target(name: "AuthApplication"),
                .target(name: "AuthDomain"),
                .target(name: "AuthModule"),
            ],
            path: "Tests/Composition/Backend",
            swiftSettings: swiftSettings
        ),
    ]
)
