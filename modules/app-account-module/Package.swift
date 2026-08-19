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
        "AvailabilityMacro=AccountModule 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
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
        .library(name: "AccountContracts", targets: ["AccountContracts"]),
        .library(name: "AccountApplication", targets: ["AccountApplication"]),
        .library(
            name: "AccountInfrastructure",
            targets: ["AccountInfrastructure"]
        ),
        .library(name: "AccountAdminAPI", targets: ["AccountAdminAPI"]),
        .library(name: "AccountAppAPI", targets: ["AccountAppAPI"]),
        .library(
            name: "AccountSharedOpenAPIGenerator",
            targets: ["AccountSharedOpenAPIGenerator"]
        ),
        .library(name: "AccountBackend", targets: ["AccountBackend"]),
        .library(name: "AccountFrontend", targets: ["AccountFrontend"]),
        .executable(
            name: "AccountAdminOpenAPIGenerator",
            targets: ["AccountAdminOpenAPIGenerator"]
        ),
        .executable(
            name: "AccountAppOpenAPIGenerator",
            targets: ["AccountAppOpenAPIGenerator"]
        ),
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
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.2"
        ),
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

        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
        .package(path: "../app-user-module"),

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
            name: "AccountContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "BCrypt", package: "swift-bcrypt"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .target(name: "AccountDomain"),
                .product(name: "UserApplication", package: "app-user-module"),
                .product(name: "UserDomain", package: "app-user-module"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AccountContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "BCrypt", package: "swift-bcrypt"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "UserApplication", package: "app-user-module"),
                .product(name: "UserInfrastructure", package: "app-user-module"),
                .target(name: "AccountApplication"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AccountContracts"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountAdminAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AccountContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "UserApplication", package: "app-user-module")],
            path: "Sources/APIs/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountAppAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AccountContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "UserApplication", package: "app-user-module")],
            path: "Sources/APIs/App",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountSharedOpenAPIGenerator",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "OpenAPIKit", package: "OpenAPIKit"),
                .product(
                    name: "UserSharedOpenAPIGenerator",
                    package: "app-user-module"
                )
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "AccountAdminOpenAPIGenerator",
            dependencies: [
                .target(name: "AccountSharedOpenAPIGenerator"),
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "OpenAPIKit", package: "OpenAPIKit"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams")
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "AccountAppOpenAPIGenerator",
            dependencies: [
                .target(name: "AccountSharedOpenAPIGenerator"),
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "OpenAPIKit", package: "OpenAPIKit"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams")
            ],
            path: "Sources/Generators/App",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountBackend",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "BCrypt", package: "swift-bcrypt"),
                .target(name: "AccountApplication"),
                .target(name: "AccountInfrastructure"),
                .target(name: "AccountAdminAPI"),
                .target(name: "AccountAppAPI"),
                .product(name: "UserApplication", package: "app-user-module"),
                .product(name: "UserInfrastructure", package: "app-user-module"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AccountContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AccountFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),
                .target(name: "AccountAdminAPI"),
                .target(name: "AccountAppAPI"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "WebStandards", package: "swift-web-standards"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "SVG", package: "swift-web-standards"),
                .product(name: "FeatherValidation", package: "feather-validation"),
                .product(
                    name: "FeatherValidationFoundation",
                    package: "feather-validation"
                ),
                .product(
                    name: "OpenAPIAsyncHTTPClient",
                    package: "swift-openapi-async-http-client"
                ),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIOCore", package: "swift-nio"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "AccountContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "UserApplication", package: "app-user-module")],
            path: "Sources/Composition/Frontend",
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AccountDomainTests",
            dependencies: [.target(name: "AccountDomain")],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AccountApplicationTests",
            dependencies: [
                .target(name: "AccountApplication"),
                .target(name: "AccountDomain"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "AccountInfrastructureTests",
            dependencies: [
                .product(
                    name: "FeatherDatabasePostgres",
                    package: "feather-database-postgres"
                ),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .target(name: "AccountInfrastructure"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
