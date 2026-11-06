// swift-tools-version:6.3
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .strictMemorySafety(),
    .treatAllWarnings(as: .error),
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
        .executable(name: "WebStatic", targets: ["WebStatic"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.22.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird-auth",
            from: "2.3.0"
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
            url: "https://github.com/vapor/postgres-nio",
            from: "1.32.2"
        ),
        .package(
            url: "https://github.com/apple/swift-nio-ssl",
            from: "2.34.0"
        ),
        .package(
            url: "https://github.com/apple/swift-configuration",
            exact: "1.0.2",
            traits: [.defaults, "CommandLineArguments"]
        ),
        .package(
            url: "https://github.com/apple/swift-system",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-mustache",
            from: "2.1.1"
        ),
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.14.0"
        ),
        .package(
            url: "https://github.com/swift-server/swift-service-lifecycle",
            from: "2.0.0"
        ),
        .package(
            url:
                "https://github.com/hummingbird-project/swift-openapi-hummingbird",
            from: "2.0.1"
        ),
        .package(
            url:
                "https://github.com/feather-framework/feather-database-postgres",
            exact: "1.0.0-rc.3"
        ),
        .package(
            url:
                "https://github.com/feather-framework/feather-http-hummingbird-testing",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-mail-ses",
            exact: "1.0.0-rc.4"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-mail",
            exact: "1.0.0-rc.3"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-storage",
            exact: "1.0.0-rc.3"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-storage-s3",
            exact: "1.0.0-rc.3"
        ),
        .package(
            url: "https://github.com/soto-project/soto-core",
            from: "7.0.0"
        ),
        .package(path: "../feather-core"),
        .package(
            url: "https://github.com/BinaryBirds/swift-web-standards",
            exact: "1.0.0-beta.4"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-sql",
            exact: "1.0.0-alpha.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-sql-postgres",
            exact: "1.0.0-alpha.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-dbal",
            exact: "1.0.0-alpha.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-dbal-postgres",
            exact: "1.0.0-alpha.1"
        ),
        .package(path: "../modules/cms-system-module"),
        .package(path: "../modules/cms-analytics-module"),
        .package(path: "../modules/cms-redirect-module"),
        .package(path: "../modules/cms-web-module"),
        .package(path: "../modules/cms-blog-module"),
        .package(path: "../modules/cms-news-module"),
        .package(path: "../modules/cms-user-module"),
        .package(path: "../modules/cms-auth-module"),
        .package(path: "../modules/cms-media-module"),
        .package(path: "../modules/cms-contact-module"),
        .package(path: "../modules/cms-newsletter-module"),
        .package(path: "../modules/cms-account-module"),
    ],
    targets: [
        .executableTarget(
            name: "Migrator",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(
                    name: "FeatherDatabasePostgres",
                    package: "feather-database-postgres"
                ),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(
                    name: "FeatherDBALPostgres",
                    package: "feather-dbal-postgres"
                ),
                .product(
                    name: "FeatherSQLPostgres",
                    package: "feather-sql-postgres"
                ),
                .product(name: "FeatherSQL", package: "feather-sql"),
                // kernel & module infrastructure
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(
                    name: "SystemInfrastructure",
                    package: "cms-system-module"
                ),
                .product(name: "SystemModule", package: "cms-system-module"),
                .product(
                    name: "SystemApplication",
                    package: "cms-system-module"
                ),
                .product(
                    name: "AnalyticsInfrastructure",
                    package: "cms-analytics-module"
                ),
                .product(
                    name: "RedirectInfrastructure",
                    package: "cms-redirect-module"
                ),
                .product(name: "WebInfrastructure", package: "cms-web-module"),
                .product(
                    name: "BlogInfrastructure",
                    package: "cms-blog-module"
                ),
                .product(name: "BlogModule", package: "cms-blog-module"),

                .product(
                    name: "NewsInfrastructure",
                    package: "cms-news-module"
                ),
                .product(
                    name: "UserInfrastructure",
                    package: "cms-user-module"
                ),
                .product(name: "AuthApplication", package: "cms-auth-module"),
                .product(
                    name: "AuthInfrastructure",
                    package: "cms-auth-module"
                ),
                .product(name: "AuthModule", package: "cms-auth-module"),
                .product(
                    name: "MediaInfrastructure",
                    package: "cms-media-module"
                ),
                .product(
                    name: "ContactInfrastructure",
                    package: "cms-contact-module"
                ),
                .product(
                    name: "NewsletterInfrastructure",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "AccountInfrastructure",
                    package: "cms-account-module"
                ),
                .product(name: "AccountModule", package: "cms-account-module"),
                .product(
                    name: "RedirectModule",
                    package: "cms-redirect-module"
                ),
                .product(name: "MediaModule", package: "cms-media-module"),
            ],
            swiftSettings: swiftSettings
        ),

        .executableTarget(
            name: "Worker",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(
                    name: "FeatherDatabasePostgres",
                    package: "feather-database-postgres"
                ),
                .product(
                    name: "FeatherDBALPostgres",
                    package: "feather-dbal-postgres"
                ),
                .product(name: "Jobs", package: "swift-jobs"),
                .product(name: "JobsPostgres", package: "swift-jobs-postgres"),

                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherMailSES", package: "feather-mail-ses"),
                .product(name: "FeatherStorageS3", package: "feather-storage-s3"),
                .product(name: "FeatherStorage", package: "feather-storage"),
                .product(name: "SotoCore", package: "soto-core"),

                // kernel & module infrastructure
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(
                    name: "SystemInfrastructure",
                    package: "cms-system-module"
                ),
                .product(
                    name: "AnalyticsInfrastructure",
                    package: "cms-analytics-module"
                ),
                .product(
                    name: "RedirectInfrastructure",
                    package: "cms-redirect-module"
                ),
                .product(name: "WebInfrastructure", package: "cms-web-module"),
                .product(
                    name: "BlogInfrastructure",
                    package: "cms-blog-module"
                ),

                .product(
                    name: "UserInfrastructure",
                    package: "cms-user-module"
                ),
                .product(
                    name: "AuthInfrastructure",
                    package: "cms-auth-module"
                ),
                .product(name: "AuthModule", package: "cms-auth-module"),
                .product(name: "MediaApplication", package: "cms-media-module"),
                .product(
                    name: "MediaInfrastructure",
                    package: "cms-media-module"
                ),
                .product(
                    name: "ContactInfrastructure",
                    package: "cms-contact-module"
                ),
                .product(
                    name: "NewsletterInfrastructure",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "NewsletterModule",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "AccountInfrastructure",
                    package: "cms-account-module"
                ),
                .product(name: "FeatherModuleKit", package: "feather-core"),
            ],
            swiftSettings: swiftSettings
        ),

        .executableTarget(
            name: "WebStatic",
            dependencies: [
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "Logging", package: "swift-log"),
                .product(
                    name: "ServiceLifecycle",
                    package: "swift-service-lifecycle"
                ),
            ],
            swiftSettings: swiftSettings
        ),

        .executableTarget(
            name: "WebApp",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebApp", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "WebModule", package: "cms-web-module"),

                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdAuth", package: "hummingbird-auth"),
                .product(name: "Mustache", package: "swift-mustache"),

                .product(name: "SystemWebAdmin", package: "cms-system-module"),
                .product(name: "UserWebAdmin", package: "cms-user-module"),
                .product(name: "UserModule", package: "cms-user-module"),
                .product(
                    name: "AccountWebAdmin",
                    package: "cms-account-module"
                ),
                .product(
                    name: "AccountAdminAPI",
                    package: "cms-account-module"
                ),
                .product(name: "AccountWebApp", package: "cms-account-module"),
                .product(
                    name: "RedirectWebAdmin",
                    package: "cms-redirect-module"
                ),
                .product(
                    name: "RedirectModule",
                    package: "cms-redirect-module"
                ),
                .product(
                    name: "RedirectWebApp",
                    package: "cms-redirect-module"
                ),
                .product(
                    name: "AnalyticsWebAdmin",
                    package: "cms-analytics-module"
                ),
                .product(
                    name: "AnalyticsWebApp",
                    package: "cms-analytics-module"
                ),
                .product(
                    name: "AnalyticsModule",
                    package: "cms-analytics-module"
                ),
                .product(name: "WebModuleWebApp", package: "cms-web-module"),
                .product(name: "WebModuleWebAdmin", package: "cms-web-module"),
                .product(name: "WebApplication", package: "cms-web-module"),
                .product(
                    name: "NewsletterWebAdmin",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "NewsletterWebApp",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "NewsletterModule",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "ContactWebAdmin",
                    package: "cms-contact-module"
                ),
                .product(name: "ContactWebApp", package: "cms-contact-module"),
                .product(name: "MediaWebAdmin", package: "cms-media-module"),
                .product(name: "BlogWebAdmin", package: "cms-blog-module"),
                .product(name: "BlogWebApp", package: "cms-blog-module"),
                .product(name: "NewsWebAdmin", package: "cms-news-module"),
                .product(name: "NewsWebApp", package: "cms-news-module"),
                .product(name: "AuthWebApp", package: "cms-auth-module"),
                .product(name: "AuthWebAdmin", package: "cms-auth-module"),
                .product(name: "AuthModule", package: "cms-auth-module"),
                .product(name: "ContactModule", package: "cms-contact-module"),

                .product(name: "ContactAppAPI", package: "cms-contact-module"),
                .product(name: "BlogAppAPI", package: "cms-blog-module"),
                .product(name: "NewsAppAPI", package: "cms-news-module"),

            ],
            resources: [
                .copy("Resources/Templates")
            ],
            swiftSettings: swiftSettings
        ),

        .executableTarget(
            name: "Server",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),

                .product(name: "Hummingbird", package: "hummingbird"),
                .product(
                    name: "OpenAPIHummingbird",
                    package: "swift-openapi-hummingbird"
                ),
                .product(name: "Jobs", package: "swift-jobs"),
                .product(name: "JobsPostgres", package: "swift-jobs-postgres"),

                .product(
                    name: "FeatherDatabasePostgres",
                    package: "feather-database-postgres"
                ),
                .product(
                    name: "FeatherDBALPostgres",
                    package: "feather-dbal-postgres"
                ),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "FeatherStorageS3", package: "feather-storage-s3"),
                .product(name: "FeatherStorage", package: "feather-storage"),
                .product(name: "SotoCore", package: "soto-core"),

                .product(name: "UserAdminAPI", package: "cms-user-module"),
                .product(
                    name: "AccountAdminAPI",
                    package: "cms-account-module"
                ),
                .product(name: "AccountAppAPI", package: "cms-account-module"),
                .product(name: "AccountBackend", package: "cms-account-module"),
                .product(
                    name: "AccountApplication",
                    package: "cms-account-module"
                ),
                .product(name: "AccountDomain", package: "cms-account-module"),
                .product(name: "AccountModule", package: "cms-account-module"),
                .product(name: "AuthAdminAPI", package: "cms-auth-module"),
                .product(name: "AuthAppAPI", package: "cms-auth-module"),
                .product(name: "AuthBackend", package: "cms-auth-module"),
                .product(
                    name: "RedirectAdminAPI",
                    package: "cms-redirect-module"
                ),
                .product(
                    name: "RedirectAppAPI",
                    package: "cms-redirect-module"
                ),
                .product(
                    name: "RedirectApplication",
                    package: "cms-redirect-module"
                ),
                .product(
                    name: "RedirectModule",
                    package: "cms-redirect-module"
                ),
                .product(
                    name: "AnalyticsBackend",
                    package: "cms-analytics-module"
                ),
                .product(name: "WebAdminAPI", package: "cms-web-module"),
                .product(name: "WebAppAPI", package: "cms-web-module"),
                .product(name: "WebBackend", package: "cms-web-module"),
                .product(
                    name: "NewsletterAdminAPI",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "NewsletterAppAPI",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "NewsletterApplication",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "NewsletterBackend",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "NewsletterModule",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "ContactAdminAPI",
                    package: "cms-contact-module"
                ),
                .product(name: "ContactAppAPI", package: "cms-contact-module"),
                .product(
                    name: "ContactApplication",
                    package: "cms-contact-module"
                ),
                .product(name: "ContactBackend", package: "cms-contact-module"),
                .product(name: "MediaAdminAPI", package: "cms-media-module"),
                .product(name: "MediaBackend", package: "cms-media-module"),
                .product(name: "MediaApplication", package: "cms-media-module"),
                .product(name: "BlogAdminAPI", package: "cms-blog-module"),
                .product(name: "BlogAppAPI", package: "cms-blog-module"),
                .product(name: "BlogBackend", package: "cms-blog-module"),

                .product(name: "NewsAdminAPI", package: "cms-news-module"),
                .product(name: "NewsAppAPI", package: "cms-news-module"),
                .product(name: "NewsBackend", package: "cms-news-module"),
                .product(name: "NewsApplication", package: "cms-news-module"),

                // kernel & module infrastructure
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(
                    name: "SystemInfrastructure",
                    package: "cms-system-module"
                ),
                .product(name: "SystemModule", package: "cms-system-module"),
                .product(
                    name: "RedirectInfrastructure",
                    package: "cms-redirect-module"
                ),
                .product(name: "WebInfrastructure", package: "cms-web-module"),
                .product(
                    name: "BlogInfrastructure",
                    package: "cms-blog-module"
                ),
                .product(name: "BlogModule", package: "cms-blog-module"),

                .product(
                    name: "NewsInfrastructure",
                    package: "cms-news-module"
                ),
                .product(
                    name: "UserInfrastructure",
                    package: "cms-user-module"
                ),
                .product(name: "UserDomain", package: "cms-user-module"),
                .product(
                    name: "AuthInfrastructure",
                    package: "cms-auth-module"
                ),
                .product(name: "AuthModule", package: "cms-auth-module"),
                .product(
                    name: "MediaInfrastructure",
                    package: "cms-media-module"
                ),
                .product(
                    name: "ContactInfrastructure",
                    package: "cms-contact-module"
                ),
                .product(
                    name: "NewsletterInfrastructure",
                    package: "cms-newsletter-module"
                ),
                .product(
                    name: "AccountInfrastructure",
                    package: "cms-account-module"
                ),
                .product(name: "SystemBackend", package: "cms-system-module"),
                .product(
                    name: "RedirectBackend",
                    package: "cms-redirect-module"
                ),
                .product(name: "UserBackend", package: "cms-user-module"),
                .product(name: "UserModule", package: "cms-user-module"),

            ],
            swiftSettings: swiftSettings
        ),

        .testTarget(
            name: "ServerTests",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .product(
                    name: "FeatherHTTPHummingbirdTesting",
                    package: "feather-http-hummingbird-testing"
                ),
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .product(
                    name: "FeatherDatabasePostgres",
                    package: "feather-database-postgres"
                ),
                .product(
                    name: "FeatherDBALPostgres",
                    package: "feather-dbal-postgres"
                ),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(name: "JobsPostgres", package: "swift-jobs-postgres"),
                .product(
                    name: "SystemApplication",
                    package: "cms-system-module"
                ),
                .product(
                    name: "PostgresMigrations",
                    package: "postgres-migrations"
                ),
                .product(name: "FeatherStorageTesting", package: "feather-storage"),
                .product(name: "FeatherStorage", package: "feather-storage"),
                .product(
                    name: "AccountAdminAPI",
                    package: "cms-account-module"
                ),
                .product(
                    name: "RedirectModule",
                    package: "cms-redirect-module"
                ),
                .product(name: "UserAdminAPI", package: "cms-user-module"),
                .product(name: "BlogModule", package: "cms-blog-module"),
                .product(name: "WebModule", package: "cms-web-module"),
                .product(
                    name: "MediaInfrastructure",
                    package: "cms-media-module"
                ),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(
                    name: "FeatherInfrastructure",
                    package: "feather-core"
                ),
                .target(name: "Server"),
            ],
            swiftSettings: swiftSettings
        ),

        .testTarget(
            name: "WorkerTests",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .target(name: "Worker"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherMailTesting", package: "feather-mail"),
            ],
            swiftSettings: swiftSettings
        ),

        .testTarget(
            name: "MigratorTests",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .target(name: "Migrator"),
            ],
            swiftSettings: swiftSettings
        ),

        .testTarget(
            name: "WebAppTests",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "WebComponents", package: "swift-web-standards"),
                .product(name: "AuthModule", package: "cms-auth-module"),
                .product(
                    name: "AccountWebAdmin",
                    package: "cms-account-module"
                ),
                .product(name: "AccountWebApp", package: "cms-account-module"),
                .product(name: "WebModuleWebApp", package: "cms-web-module"),
                .product(name: "WebModuleWebAdmin", package: "cms-web-module"),
                .target(name: "WebApp"),
                .target(name: "WebStatic"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
