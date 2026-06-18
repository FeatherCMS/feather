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
        "AvailabilityMacro=WebModule 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
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
    name: "app-web-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "WebDomain", targets: ["WebDomain"]),
        .library(name: "WebApplication", targets: ["WebApplication"]),
        .library(name: "WebInfrastructure", targets: ["WebInfrastructure"]),
    ],
    dependencies: [
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
            exact: "1.0.0-beta.5"
        ),

        //        .package(
        //            url: "https://github.com/feather-framework/feather-mail",
        //            exact: "1.0.0-beta.3"
        //        ),

        .package(path: "../app-kernel"),
        .package(path: "../app-system-module"),

        .package(
            url:
                "https://github.com/feather-framework/feather-database-postgres",
            exact: "1.0.0-beta.6"
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
            name: "WebDomain",
            dependencies: [
                .product(name: "Domain", package: "app-kernel")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "WebApplication",
            dependencies: [
                .product(name: "Application", package: "app-kernel"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .target(name: "WebDomain"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "WebInfrastructure",
            dependencies: [
                .product(name: "Infrastructure", package: "app-kernel"),
                .target(name: "WebApplication"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "WebDomainTests",
            dependencies: [
                .target(name: "WebDomain")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "WebApplicationTests",
            dependencies: [
                .target(name: "WebApplication")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "WebInfrastructureTests",
            dependencies: [
                .target(name: "WebInfrastructure"),
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
