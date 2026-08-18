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
        "AvailabilityMacro=SystemModule 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
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
    name: "app-system-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "SystemDomain", targets: ["SystemDomain"]),
        .library(name: "SystemContracts", targets: ["SystemContracts"]),
        .library(name: "SystemApplication", targets: ["SystemApplication"]),
        .library(name: "SystemInfrastructure", targets: ["SystemInfrastructure"]),
        .library(name: "SystemAdminAPI", targets: ["SystemAdminAPI"]),
        .library(name: "SystemAppAPI", targets: ["SystemAppAPI"]),
        .library(name: "SystemBackend", targets: ["SystemBackend"]),
        .library(name: "SystemFrontend", targets: ["SystemFrontend"]),
        .executable(name: "SystemAdminOpenAPIGenerator", targets: ["SystemAdminOpenAPIGenerator"]),
        .executable(name: "SystemAppOpenAPIGenerator", targets: ["SystemAppOpenAPIGenerator"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.15.0"
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
        .package(
            url: "https://github.com/apple/swift-nio.git",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-database-postgres",
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
        .package(path: "../../feather-core"),
    ],
    targets: [
        .target(
            name: "SystemContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "SystemDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "SystemContracts")
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "SystemApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .target(name: "SystemDomain"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                ],
            path: "Sources/Layers/Application",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "SystemInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .target(name: "SystemApplication"),
            
                .product(name: "FeatherContracts", package: "feather-core")],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .target(
            name: "SystemAdminAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "SystemApplication")],
            path: "Sources/APIs/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "SystemAppAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "SystemApplication")],
            path: "Sources/APIs/App",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .executableTarget(
            name: "SystemAdminOpenAPIGenerator",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
                .product(
                    name: "FeatherOpenAPI",
                    package: "feather-openapi"
                ),
                .product(name: "OpenAPIKit", package: "OpenAPIKit"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams")
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "SystemAppOpenAPIGenerator",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
                .product(
                    name: "FeatherOpenAPI",
                    package: "feather-openapi"
                ),
                .product(name: "OpenAPIKit", package: "OpenAPIKit"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams")
            ],
            path: "Sources/Generators/App",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .target(
            name: "SystemBackend",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .target(name: "SystemApplication"),
                .target(name: "SystemInfrastructure"),
                .target(name: "SystemAdminAPI"),
                .target(name: "SystemAppAPI"),
            
                .product(name: "FeatherContracts", package: "feather-core")],
            path: "Sources/Composition/Backend",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "SystemFrontend",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherAdmin", package: "feather-core"),
                .target(name: "SystemAdminAPI"),
                .target(name: "SystemAppAPI"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "WebStandards", package: "swift-web-standards"),
                .product(name: "FeatherValidation", package: "feather-validation"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIOCore", package: "swift-nio"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "SystemApplication")],
            path: "Sources/Composition/Frontend",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .testTarget(
            name: "SystemDomainTests",
            dependencies: [
                .target(name: "SystemDomain")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "SystemApplicationTests",
            dependencies: [
                .target(name: "SystemApplication")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "SystemInfrastructureTests",
            dependencies: [
                .target(name: "SystemInfrastructure"),
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
