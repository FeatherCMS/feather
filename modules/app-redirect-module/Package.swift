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
        "AvailabilityMacro=RedirectBackend 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
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
    name: "app-redirect-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "RedirectDomain", targets: ["RedirectDomain"]),
        .library(name: "RedirectContracts", targets: ["RedirectContracts"]),
        .library(name: "RedirectApplication", targets: ["RedirectApplication"]),
        .library(
            name: "RedirectInfrastructure",
            targets: ["RedirectInfrastructure"]
        ),
        .library(name: "RedirectBackend", targets: ["RedirectBackend"]),
        .library(name: "RedirectAdminAPI", targets: ["RedirectAdminAPI"]),
        .library(name: "RedirectAppAPI", targets: ["RedirectAppAPI"]),
        .library(
            name: "RedirectSharedOpenAPIGenerator",
            targets: ["RedirectSharedOpenAPIGenerator"]
        ),
        .executable(
            name: "RedirectAdminOpenAPIGenerator",
            targets: ["RedirectAdminOpenAPIGenerator"]
        ),
        .executable(
            name: "RedirectAppOpenAPIGenerator",
            targets: ["RedirectAppOpenAPIGenerator"]
        ),
        .library(
            name: "RedirectFrontend",
            targets: ["RedirectFrontend"]
        ),
    ],
    dependencies: [
        // [docc-plugin-placeholder]
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/binarybirds/swift-nanoid",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.2"
        ),

        //        .package(
        //            url: "https://github.com/feather-framework/feather-mail",
        //            exact: "1.0.0-beta.3"
        //        ),

        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
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
        .package(
            url: "https://github.com/apple/swift-nio",
            from: "2.0.0"
        ),

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
        //        .package(
        //            url: "https://github.com/feather-framework/feather-mail-ephemeral",
        //            exact: "1.0.0-beta.2"
        //        ),
    ],
    targets: [
        .target(
            name: "RedirectContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "RedirectDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "RedirectApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .target(name: "RedirectDomain"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "RedirectContracts"),
                .product(name: "SystemApplication", package: "app-system-module")],
            path: "Sources/Layers/Application",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "RedirectInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .target(name: "RedirectApplication"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "RedirectContracts"),],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "RedirectAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "RedirectContracts"),
                .product(name: "SystemApplication", package: "app-system-module")],
            path: "Sources/APIs/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "RedirectAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "RedirectContracts"),
                .product(name: "SystemApplication", package: "app-system-module")],
            path: "Sources/APIs/App",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "RedirectSharedOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "OpenAPIKit", package: "OpenAPIKit")
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "RedirectAdminOpenAPIGenerator",
            dependencies: [
                .target(name: "RedirectSharedOpenAPIGenerator"),
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
            name: "RedirectAppOpenAPIGenerator",
            dependencies: [
                .target(name: "RedirectSharedOpenAPIGenerator"),
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
            name: "RedirectBackend",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .target(name: "RedirectApplication"),
                .target(name: "RedirectInfrastructure"),
                .target(name: "RedirectAdminAPI"),
                .target(name: "RedirectAppAPI"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "RedirectContracts"),
                .product(name: "SystemApplication", package: "app-system-module")],
            path: "Sources/Composition/Backend",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "RedirectFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),
                .target(name: "RedirectAdminAPI"),
                .target(name: "RedirectAppAPI"),
                .target(name: "RedirectDomain"),
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
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "RedirectContracts"),
                .product(name: "SystemApplication", package: "app-system-module")],
            path: "Sources/Composition/Frontend",
            swiftSettings: defaultSwiftSettings
        ),

        .testTarget(
            name: "RedirectDomainTests",
            dependencies: [
                .target(name: "RedirectDomain")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "RedirectApplicationTests",
            dependencies: [
                .target(name: "RedirectApplication")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "RedirectInfrastructureTests",
            dependencies: [
                .target(name: "RedirectInfrastructure"),
                .product(
                    name: "FeatherDatabasePostgres",
                    package: "feather-database-postgres"
                ),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
