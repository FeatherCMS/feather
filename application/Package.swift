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
        "AvailabilityMacro=Application 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
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
    name: "application",
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
        .executable(name: "WebApp", targets: ["WebApp"]),
        .executable(name: "Static", targets: ["Static"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.22.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird-auth",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-jobs",
            from: "1.1.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-jobs-postgres",
            exact: "1.3.0"
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
            url: "https://github.com/BinaryBirds/swift-web-standards",
            exact: "1.0.0-beta.3"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-mustache",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-markdown",
            from: "0.8.0"
        ),
        .package(
            url: "https://github.com/swift-server/swift-openapi-async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-validation",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/apple/swift-nio",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.14.0"
        ),
        .package(
            url: "https://github.com/apple/swift-system.git",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/swift-server/swift-service-lifecycle",
            from: "2.0.0"
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
            exact: "1.0.0-rc.2"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-http-hummingbird-testing",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-mail-ses",
            exact: "1.0.0-rc.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-mail",
            exact: "1.0.0-rc.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-mail-ephemeral",
            exact: "1.0.0-rc.1"
        ),
        .package(
            url: "https://github.com/soto-project/soto-core",
            from: "7.0.0"
        ),
        .package(path: "../feather-core"),
        .package(path: "../modules/app-system-module"),
        .package(path: "../modules/app-analytics-module"),
        .package(path: "../modules/app-redirect-module"),
        .package(path: "../modules/app-web-module"),
        .package(path: "../modules/app-blog-module"),
        .package(path: "../modules/app-news-module"),
        .package(path: "../modules/app-user-module"),
        .package(path: "../modules/app-auth-module"),
        .package(path: "../modules/app-media-module"),
        .package(path: "../modules/app-contact-module"),
        .package(path: "../modules/app-newsletter-module"),
        .package(path: "../modules/app-account-module"),
    ],
    targets: [
        .target(
            name: "Environment",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Jobs", package: "swift-jobs"),
                .product(name: "FeatherContracts", package: "feather-core")
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
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherContracts", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),
                .product(name: "AnalyticsInfrastructure", package: "app-analytics-module"),
                .product(name: "RedirectInfrastructure", package: "app-redirect-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(name: "BlogInfrastructure", package: "app-blog-module"),

                .product(name: "NewsInfrastructure", package: "app-news-module"),
                .product(name: "UserInfrastructure", package: "app-user-module"),
                .product(name: "AuthApplication", package: "app-auth-module"),
                .product(name: "AuthInfrastructure", package: "app-auth-module"),
                .product(name: "MediaInfrastructure", package: "app-media-module"),
                .product(name: "ContactInfrastructure", package: "app-contact-module"),
                .product(name: "NewsletterInfrastructure", package: "app-newsletter-module"),
                .product(name: "AccountInfrastructure", package: "app-account-module"),
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

                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherMailSES", package: "feather-mail-ses"),
                .product(name: "SotoCore", package: "soto-core"),

                // kernel & module infrastructure
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),
                .product(name: "AnalyticsInfrastructure", package: "app-analytics-module"),
                .product(name: "RedirectInfrastructure", package: "app-redirect-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(name: "BlogInfrastructure", package: "app-blog-module"),

                .product(name: "UserInfrastructure", package: "app-user-module"),
                .product(name: "AuthInfrastructure", package: "app-auth-module"),
                .product(name: "MediaInfrastructure", package: "app-media-module"),
                .product(name: "ContactInfrastructure", package: "app-contact-module"),
                .product(name: "NewsletterInfrastructure", package: "app-newsletter-module"),
                .product(name: "AccountInfrastructure", package: "app-account-module"),
                .target(name: "Environment"),
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            swiftSettings: defaultSwiftSettings
        ),

        .executableTarget(
            name: "Static",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
                .product(name: "SystemPackage", package: "swift-system"),
            ],
            swiftSettings: defaultSwiftSettings
        ),

        .executableTarget(
            name: "WebApp",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdAuth", package: "hummingbird-auth"),
                .product(name: "Markdown", package: "swift-markdown"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "FeatherValidation", package: "feather-validation"),
                .product(name: "FeatherValidationFoundation", package: "feather-validation"),
                .product(name: "Mustache", package: "swift-mustache"),
                .product(name: "WebStandards", package: "swift-web-standards"),
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "SVG", package: "swift-web-standards"),
                .product(name: "FeatherAdmin", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "SystemFrontend", package: "app-system-module"),
                .product(name: "UserFrontend", package: "app-user-module"),
                .product(name: "AccountFrontend", package: "app-account-module"),
                .product(name: "RedirectFrontend", package: "app-redirect-module"),
                .product(name: "AnalyticsFrontend", package: "app-analytics-module"),
                .product(name: "WebFrontend", package: "app-web-module"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebAppAPI", package: "app-web-module"),
                .product(name: "NewsletterFrontend", package: "app-newsletter-module"),
                .product(name: "ContactFrontend", package: "app-contact-module"),
                .product(name: "ContactAppAPI", package: "app-contact-module"),
                .product(name: "MediaFrontend", package: "app-media-module"),
                .product(name: "MediaAdminAPI", package: "app-media-module"),
                .product(name: "BlogFrontend", package: "app-blog-module"),
                .product(name: "BlogAppAPI", package: "app-blog-module"),
                .product(name: "NewsFrontend", package: "app-news-module"),
                .product(name: "NewsAppAPI", package: "app-news-module"),
                .product(name: "BlogAdminAPI", package: "app-blog-module"),
                .product(name: "AuthFrontend", package: "app-auth-module"),
                .product(name: "AuthAppAPI", package: "app-auth-module"),
                .product(name: "WebAdminAPI", package: "app-web-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(name: "BlogInfrastructure", package: "app-blog-module"),
                .product(name: "NewsInfrastructure", package: "app-news-module"),

                .product(name: "AnalyticsAdminAPI", package: "app-analytics-module"),
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            resources: [
                .copy("Resources/Themes"),
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
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherBackend", package: "feather-core"),

                .product(name: "UserAdminAPI", package: "app-user-module"),
                .product(name: "UserAppAPI", package: "app-user-module"),
                .product(name: "AccountAdminAPI", package: "app-account-module"),
                .product(name: "AccountAppAPI", package: "app-account-module"),
                .product(name: "AccountBackend", package: "app-account-module"),
                .product(name: "AuthAdminAPI", package: "app-auth-module"),
                .product(name: "AuthAppAPI", package: "app-auth-module"),
                .product(name: "AuthBackend", package: "app-auth-module"),
                .product(name: "RedirectAdminAPI", package: "app-redirect-module"),
                .product(name: "RedirectAppAPI", package: "app-redirect-module"),
                .product(name: "AnalyticsBackend", package: "app-analytics-module"),
                .product(name: "WebAdminAPI", package: "app-web-module"),
                .product(name: "WebAppAPI", package: "app-web-module"),
                .product(name: "WebBackend", package: "app-web-module"),
                .product(name: "NewsletterAdminAPI", package: "app-newsletter-module"),
                .product(name: "NewsletterAppAPI", package: "app-newsletter-module"),
                .product(name: "NewsletterBackend", package: "app-newsletter-module"),
                .product(name: "ContactAdminAPI", package: "app-contact-module"),
                .product(name: "ContactAppAPI", package: "app-contact-module"),
                .product(name: "ContactBackend", package: "app-contact-module"),
                .product(name: "MediaAdminAPI", package: "app-media-module"),
                .product(name: "MediaBackend", package: "app-media-module"),
                .product(name: "BlogAdminAPI", package: "app-blog-module"),
                .product(name: "BlogAppAPI", package: "app-blog-module"),
                .product(name: "BlogBackend", package: "app-blog-module"),

                .product(name: "NewsAppAPI", package: "app-news-module"),
                .product(name: "NewsBackend", package: "app-news-module"),
                .product(name: "NewsApplication", package: "app-news-module"),

                // kernel & module infrastructure
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),
                .product(name: "RedirectInfrastructure", package: "app-redirect-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(name: "BlogInfrastructure", package: "app-blog-module"),

                .product(name: "NewsInfrastructure", package: "app-news-module"),
                .product(name: "UserInfrastructure", package: "app-user-module"),
                .product(name: "AuthInfrastructure", package: "app-auth-module"),
                .product(name: "MediaInfrastructure", package: "app-media-module"),
                .product(name: "ContactInfrastructure", package: "app-contact-module"),
                .product(name: "NewsletterInfrastructure", package: "app-newsletter-module"),
                .product(name: "AccountInfrastructure", package: "app-account-module"),
                .product(name: "SystemBackend", package: "app-system-module"),
                .product(name: "RedirectBackend", package: "app-redirect-module"),
                .product(name: "UserBackend", package: "app-user-module"),

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
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(name: "JobsPostgres", package: "swift-jobs-postgres"),
                .product(name: "PostgresMigrations", package: "postgres-migrations"),
                .product(name: "AccountAdminAPI", package: "app-account-module"),
                .target(name: "Server"),
            ],
            swiftSettings: defaultSwiftSettings
        ),

        .testTarget(
            name: "WorkerTests",
            dependencies: [
                .target(name: "Worker"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherMailEphemeral", package: "feather-mail-ephemeral"),
                .target(name: "Environment"),
            ],
            swiftSettings: defaultSwiftSettings
        ),

        .testTarget(
            name: "WebAppTests",
            dependencies: [
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .product(name: "FeatherAdmin", package: "feather-core"),
                .product(name: "FeatherContracts", package: "feather-core"),
                .product(name: "AccountFrontend", package: "app-account-module"),
                .target(name: "WebApp"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
