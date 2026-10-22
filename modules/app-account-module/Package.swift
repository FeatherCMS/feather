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
        .library(name: "AccountModule", targets: ["AccountModule"]),
        .library(name: "AccountApplication", targets: ["AccountApplication"]),
        .library(name: "AccountInfrastructure", targets: ["AccountInfrastructure"]),
        .library(name: "AccountAdminAPI", targets: ["AccountAdminAPI"]),
        .library(name: "AccountAppAPI", targets: ["AccountAppAPI"]),
        .library(name: "AccountBackend", targets: ["AccountBackend"]),
        .library(name: "AccountWebAdmin", targets: ["AccountWebAdmin"]),
        .library(name: "AccountWebApp", targets: ["AccountWebApp"]),
        .executable(name: "AccountAdminOpenAPIGenerator", targets: ["AccountAdminOpenAPIGenerator"]),
        .executable(name: "AccountAppOpenAPIGenerator", targets: ["AccountAppOpenAPIGenerator"]),
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
            url: "https://github.com/apple/swift-http-types",
            from: "1.8.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.27.0"
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
        .package(
            url: "https://github.com/swift-server/async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/swift-server/swift-openapi-async-http-client",
            from: "1.0.0"
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
            url: "https://github.com/feather-framework/feather-mail",
            exact: "1.0.0-rc.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-openapi",
            exact: "1.0.0-rc.2"
        ),
        .package(path: "../app-auth-module"),
        .package(path: "../app-media-module"),
        .package(path: "../app-system-module"),
        .package(path: "../app-user-module"),

        // MARK: - test dependencies

        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.3"
        ),
    ],
    targets: [
        .target(
            name: "AccountModule",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core")
            ],
            path: "Sources/Module",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AccountDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "AccountModule"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AccountApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherDomain", package: "feather-core"),

                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "AuthDomain", package: "app-auth-module"),
                .product(name: "AuthModule", package: "app-auth-module"),
                .product(name: "UserApplication", package: "app-user-module"),
                .product(name: "UserDomain", package: "app-user-module"),
                .product(name: "UserModule", package: "app-user-module"),

                .target(name: "AccountDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AccountInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "FeatherDatabase", package: "feather-database"),

                .product(name: "AuthInfrastructure", package: "app-auth-module"),
                .product(name: "AuthModule", package: "app-auth-module"),
                .product(name: "UserInfrastructure", package: "app-user-module"),
                .product(name: "UserDomain", package: "app-user-module"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "UserModule", package: "app-user-module"),

                .target(name: "AccountModule"),
                .target(name: "AccountApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AccountAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: sharedSwiftSettings + [
                .unsafeFlags(["-suppress-warnings"])
            ]
        ),
        .target(
            name: "AccountAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: sharedSwiftSettings + [
                .unsafeFlags(["-suppress-warnings"])
            ]
        ),
        .executableTarget(
            name: "AccountAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "AccountAppOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
                .product(name: "UserOpenAPIGeneratorSupport", package: "app-user-module"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AccountBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherApplication", package: "feather-core"),

                .product(name: "AuthDomain", package: "app-auth-module"),
                .product(name: "AuthModule", package: "app-auth-module"),
                .product(name: "AuthInfrastructure", package: "app-auth-module"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "UserInfrastructure", package: "app-user-module"),
                .product(name: "UserDomain", package: "app-user-module"),
                .product(name: "UserModule", package: "app-user-module"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),

                .target(name: "AccountInfrastructure"),
                .target(name: "AccountAdminAPI"),
                .target(name: "AccountAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AccountWebAdmin",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "WebBuilders", package: "swift-web-standards"),
                .product(name: "WebComponents", package: "swift-web-standards"),

                .product(name: "AuthAdminAPI", package: "app-auth-module"),
                .product(name: "AuthAppAPI", package: "app-auth-module"),
                .product(name: "MediaWebAdmin", package: "app-media-module"),
                .product(name: "SystemAdminAPI", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),
                .product(name: "UserAdminAPI", package: "app-user-module"),
                .product(name: "UserModule", package: "app-user-module"),
                .product(name: "UserWebAdmin", package: "app-user-module"),

                .target(name: "AccountModule"),
                .target(name: "AccountAdminAPI"),
                .target(name: "AccountAppAPI"),
            ],
            path: "Sources/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AccountWebApp",
            dependencies: [
                .product(name: "FeatherWebApp", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "WebBuilders", package: "swift-web-standards"),
                .product(name: "WebComponents", package: "swift-web-standards"),

                .target(name: "AccountModule"),
                .target(name: "AccountAppAPI"),
            ],
            path: "Sources/Composition/WebApp",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AccountDomainTests",
            dependencies: [
                .target(name: "AccountModule"),
                .target(name: "AccountDomain"),
            ],
            path: "Tests/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AccountApplicationTests",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
                .target(name: "AccountModule"),
                .product(name: "AuthModule", package: "app-auth-module"),
                .product(name: "AuthDomain", package: "app-auth-module"),
                .product(name: "UserDomain", package: "app-user-module"),
                .product(name: "UserModule", package: "app-user-module"),
                .target(name: "AccountApplication"),
            ],
            path: "Tests/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AccountInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDatabaseTesting", package: "feather-database"),
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "FeatherDBAL", package: "feather-dbal"),

                .target(name: "AccountModule"),
                .target(name: "AccountInfrastructure"),
            ],
            path: "Tests/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AccountBackendTests",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherHTTP", package: "feather-http"),
                .product(name: "FeatherHTTPHummingbirdTesting", package: "feather-http-hummingbird-testing"),
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "FeatherTesting", package: "feather-core"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "FeatherDatabaseTesting", package: "feather-database"),
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .product(name: "OpenAPIHummingbird", package: "swift-openapi-hummingbird"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),

                .target(name: "AccountBackend"),
                .target(name: "AccountAdminAPI"),
                .target(name: "AccountModule"),
            ],
            path: "Tests/Composition/Backend",
            swiftSettings: swiftSettings
        ),
    ]
)
