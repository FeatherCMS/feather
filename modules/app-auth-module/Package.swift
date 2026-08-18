// swift-tools-version:6.1
import PackageDescription

// NOTE: https://github.com/swift-server/swift-http-server/blob/main/Package.swift
var defaultSwiftSettings: [SwiftSetting] = [
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0441-formalize-language-mode-terminology.md
    .swiftLanguageMode(.v6),
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md
    .enableUpcomingFeature("MemberImportVisibility"),
    // https://forums.swift.org/t/experimental-support-for-lifetime-dependencies-in-swift-6-2-and-beyond/78638
    .enableExperimentalFeature("Lifetimes"),
    // https://github.com/swiftlang/swift/pull/65218
    .enableExperimentalFeature(
        "AvailabilityMacro=AuthBackend 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
    ),
]

#if compiler(>=6.2)
defaultSwiftSettings.append(
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
    .enableUpcomingFeature("NonisolatedNonsendingByDefault")
)
#endif

defaultSwiftSettings += [
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
        .library(name: "AuthAdminAPI", targets: ["AuthAdminAPI"]),
        .library(name: "AuthAppAPI", targets: ["AuthAppAPI"]),
        .library(name: "AuthSharedOpenAPIGenerator", targets: ["AuthSharedOpenAPIGenerator"]),
        .executable(name: "AuthAdminOpenAPIGenerator", targets: ["AuthAdminOpenAPIGenerator"]),
        .executable(name: "AuthAppOpenAPIGenerator", targets: ["AuthAppOpenAPIGenerator"]),
        .library(name: "AuthFrontend", targets: ["AuthFrontend"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]

        //        .package(
        //            url: "https://github.com/apple/swift-log",
        //            from: "1.0.0"
        //        ),
        //        .package(
        //            url: "https://github.com/binarybirds/swift-nanoid",
        //            from: "1.0.0"
        //        ),

        .package(
            url: "https://github.com/binarybirds/swift-bcrypt",
            from: "2.0.1"
        ),
        .package(
            url: "https://github.com/apple/swift-nio",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/binarybirds/swift-nanoid",
            from: "1.0.0"
        ),

        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.2"
        ),

        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
        .package(path: "../app-user-module"),
        .package(path: "../app-web-module"),
        .package(
            url: "https://github.com/feather-framework/feather-openapi",
            exact: "1.0.0-beta.7"
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
            from: "1.9.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.20.1"
        ),
        .package(
            url: "https://github.com/BinaryBirds/swift-web-standards",
            exact: "1.0.0-beta.3"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-validation",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/swift-server/swift-openapi-async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/swift-server/async-http-client.git",
            from: "1.0.0"
        ),

        // MARK: - test dependencies

        .package(
            url:
                "https://github.com/feather-framework/feather-database-postgres",
            exact: "1.0.0-rc.2"
        ),
        .package(
            url: "https://github.com/vapor/postgres-nio.git",
            from: "1.32.2"
        ),
        .package(
            url: "https://github.com/apple/swift-nio-ssl.git",
            from: "2.34.0"
        ),
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
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "UserDomain", package: "app-user-module"),
                .product(name: "UserApplication", package: "app-user-module"),
                .target(name: "AuthDomain"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AuthContracts"),

                .product(name: "WebApplication", package: "app-web-module"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "BCrypt", package: "swift-bcrypt"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "UserDomain", package: "app-user-module"),
                .product(
                    name: "UserInfrastructure",
                    package: "app-user-module"
                ),
                .target(name: "AuthDomain"),
                .target(name: "AuthApplication"),
                .product(name: "WebApplication", package: "app-web-module"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AuthContracts"),


                .product(name: "UserApplication", package: "app-user-module")],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AuthContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "UserApplication", package: "app-user-module")],
            path: "Sources/APIs/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AuthContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "UserApplication", package: "app-user-module")],
            path: "Sources/APIs/App",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthSharedOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "UserSharedOpenAPIGenerator", package: "app-user-module"),
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "OpenAPIKit", package: "OpenAPIKit")
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "AuthAdminOpenAPIGenerator",
            dependencies: [
                .target(name: "AuthSharedOpenAPIGenerator"),
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "OpenAPIKit", package: "OpenAPIKit"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams")
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "AuthAppOpenAPIGenerator",
            dependencies: [
                .target(name: "AuthSharedOpenAPIGenerator"),
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "OpenAPIKit", package: "OpenAPIKit"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams")
            ],
            path: "Sources/Generators/App",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthBackend",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "BCrypt", package: "swift-bcrypt"),
                .product(name: "NanoID", package: "swift-nanoid"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemAdminAPI", package: "app-system-module"),
                .product(name: "UserApplication", package: "app-user-module"),
                .product(name: "UserDomain", package: "app-user-module"),
                .product(name: "UserInfrastructure", package: "app-user-module"),
                .product(name: "UserBackend", package: "app-user-module"),
                .target(name: "AuthApplication"),
                .target(name: "AuthInfrastructure"),
                .target(name: "AuthAdminAPI"),
                .target(name: "AuthAppAPI"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AuthContracts"),

                .product(name: "WebApplication", package: "app-web-module"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),
                .target(name: "AuthAdminAPI"),
                .target(name: "AuthAppAPI"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "WebStandards", package: "swift-web-standards"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "SVG", package: "swift-web-standards"),
                .product(name: "FeatherValidation", package: "feather-validation"),
                .product(name: "FeatherValidationFoundation", package: "feather-validation"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIOCore", package: "swift-nio"),
        .product(name: "UserAdminAPI", package: "app-user-module"),
        .product(name: "UserFrontend", package: "app-user-module"),
                .product(name: "UserAppAPI", package: "app-user-module")
                , .product(name: "SystemAdminAPI", package: "app-system-module")
                , .product(name: "SystemFrontend", package: "app-system-module"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AuthContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "UserApplication", package: "app-user-module")],
            path: "Sources/Composition/Frontend",
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AuthDomainTests",
            dependencies: [
                .target(name: "AuthDomain")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AuthApplicationTests",
            dependencies: [
                .target(name: "AuthApplication")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AuthInfrastructureTests",
            dependencies: [
                .product(
                    name: "FeatherDatabasePostgres",
                    package: "feather-database-postgres"
                ),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(
                    name: "SystemInfrastructure",
                    package: "app-system-module"
                ),
                .product(
                    name: "UserInfrastructure",
                    package: "app-user-module"
                ),
                .target(name: "AuthInfrastructure"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
