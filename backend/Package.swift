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
    .enableExperimentalFeature("AvailabilityMacro=backend 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"),
]

#if compiler(>=6.2)
defaultSwiftSettings.append(
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
    .enableUpcomingFeature("NonisolatedNonsendingByDefault")
)
#endif

defaultSwiftSettings += [
    .enableExperimentalFeature("StrictConcurrency=complete"),
    .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
]

let package = Package(
    name: "backend",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .executable(name: "Server", targets: ["Server"]),
        .executable(name: "Migrator", targets: ["Migrator"]),
        .executable(name: "Worker", targets: ["Worker"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.22.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-jobs",
            from: "1.1.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-jobs-postgres",
            from: "1.2.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/postgres-migrations",
            from: "1.1.0"
        ),
        .package(
            url: "https://github.com/vapor/postgres-nio.git",
            from: "1.32.2"
        ),
        .package(
            url: "https://github.com/apple/swift-nio-ssl.git",
            from: "2.34.0"
        ),
        .package(
            url: "https://github.com/apple/swift-configuration",
            exact: "1.0.2",
            traits: [.defaults, "CommandLineArguments"]
        ),
        .package(
            url: "https://github.com/apple/swift-nio",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-openapi-hummingbird",
            from: "2.0.1"
        ),
        .package(
            url: "https://github.com/BinaryBirds/swift-nanoid",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/binarybirds/swift-bcrypt",
            from: "2.0.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-database-postgres",
            exact: "1.0.0-beta.6"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-http-hummingbird-testing",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-mail-ephemeral",
            exact: "1.0.0-beta.2"
        ),
        .package(path: "../openapi"),
        .package(path: "./app-modules/app-kernel"),
        .package(path: "./app-modules/app-system-module"),
        .package(path: "./app-modules/app-analytics-module"),
        .package(path: "./app-modules/app-redirect-module"),
        .package(path: "./app-modules/app-web-module"),
        .package(path: "./app-modules/app-blog-module"),
        .package(path: "./app-modules/app-user-module"),
        .package(path: "./app-modules/app-auth-module"),
        .package(path: "./app-modules/app-media-module"),
    ],
    targets: [
        .target(
            name: "Environment",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "Logging", package: "swift-log"),
            ],
            swiftSettings: defaultSwiftSettings
        ),

        .executableTarget(
            name: "Migrator",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NanoID", package: "swift-nanoid"),
                .product(name: "BCrypt", package: "swift-bcrypt"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(name: "FeatherDatabasePostgres", package: "feather-database-postgres"),
                // kernel & module infrastructure
                .product(name: "Infrastructure", package: "app-kernel"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),
                .product(name: "AnalyticsInfrastructure", package: "app-analytics-module"),
                .product(name: "RedirectInfrastructure", package: "app-redirect-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(name: "BlogInfrastructure", package: "app-blog-module"),
                .product(name: "UserInfrastructure", package: "app-user-module"),
                .product(name: "AuthApplication", package: "app-auth-module"),
                .product(name: "AuthInfrastructure", package: "app-auth-module"),
                .product(name: "MediaInfrastructure", package: "app-media-module"),

                .target(name: "Environment"),
            ],
            swiftSettings: defaultSwiftSettings
        ),

        .executableTarget(
            name: "Worker",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NanoID", package: "swift-nanoid"),
                .product(name: "BCrypt", package: "swift-bcrypt"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(name: "FeatherDatabasePostgres", package: "feather-database-postgres"),
                .product(name: "Jobs", package: "swift-jobs"),
                .product(name: "JobsPostgres", package: "swift-jobs-postgres"),
                // kernel & module infrastructure
                .product(name: "Infrastructure", package: "app-kernel"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),
                .product(name: "AnalyticsInfrastructure", package: "app-analytics-module"),
                .product(name: "RedirectInfrastructure", package: "app-redirect-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(name: "BlogInfrastructure", package: "app-blog-module"),
                .product(name: "UserInfrastructure", package: "app-user-module"),
                .product(name: "AuthInfrastructure", package: "app-auth-module"),
                .product(name: "MediaInfrastructure", package: "app-media-module"),

                .target(name: "Environment"),
            ],
            swiftSettings: defaultSwiftSettings
        ),

        .executableTarget(
            name: "Server",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NanoID", package: "swift-nanoid"),
                .product(name: "BCrypt", package: "swift-bcrypt"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),

                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "OpenAPIHummingbird", package: "swift-openapi-hummingbird"),
                .product(name: "Jobs", package: "swift-jobs"),
                .product(name: "JobsPostgres", package: "swift-jobs-postgres"),

                .product(name: "FeatherDatabasePostgres", package: "feather-database-postgres"),
                .product(name: "FeatherMailEphemeral", package: "feather-mail-ephemeral"),

                .product(name: "AppOpenAPI", package: "openapi"),
                .product(name: "AdminOpenAPI", package: "openapi"),

                // kernel & module infrastructure
                .product(name: "Infrastructure", package: "app-kernel"),
                .product(name: "AnalyticsApplication", package: "app-analytics-module"),
                .product(name: "AnalyticsInfrastructure", package: "app-analytics-module"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),
                .product(name: "RedirectInfrastructure", package: "app-redirect-module"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "BlogApplication", package: "app-blog-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(name: "BlogInfrastructure", package: "app-blog-module"),
                .product(name: "UserInfrastructure", package: "app-user-module"),
                .product(name: "AuthInfrastructure", package: "app-auth-module"),
                .product(name: "MediaInfrastructure", package: "app-media-module"),

                .target(name: "Environment"),
            ],
            swiftSettings: defaultSwiftSettings
        ),

        .testTarget(
            name: "ServerTests",
            dependencies: [
                .product(name: "FeatherHTTPHummingbirdTesting", package: "feather-http-hummingbird-testing"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .product(name: "FeatherDatabasePostgres", package: "feather-database-postgres"),
                .product(name: "FeatherMailEphemeral", package: "feather-mail-ephemeral"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(name: "JobsPostgres", package: "swift-jobs-postgres"),
                .product(name: "PostgresMigrations", package: "postgres-migrations"),
                .target(name: "Server"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
