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
        "AvailabilityMacro=AuthModule 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
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
        .library(name: "AuthApplication", targets: ["AuthApplication"]),
        .library(name: "AuthInfrastructure", targets: ["AuthInfrastructure"]),
    ],
    dependencies: [
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
            exact: "1.0.0-beta.5"
        ),

        .package(path: "../app-kernel"),
        .package(path: "../app-system-module"),
        .package(path: "../app-user-module"),

        // MARK: - test dependencies

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
    ],
    targets: [
        .target(
            name: "AuthDomain",
            dependencies: [
                .product(name: "Domain", package: "app-kernel")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthApplication",
            dependencies: [
                .product(name: "Application", package: "app-kernel"),
                .product(name: "Domain", package: "app-kernel"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "UserDomain", package: "app-user-module"),
                .product(name: "UserApplication", package: "app-user-module"),
                .target(name: "AuthDomain"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AuthInfrastructure",
            dependencies: [
                .product(name: "Infrastructure", package: "app-kernel"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "BCrypt", package: "swift-bcrypt"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .target(name: "AuthDomain"),
                .target(name: "AuthApplication"),
            ],
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
