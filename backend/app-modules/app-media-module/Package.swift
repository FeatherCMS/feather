// swift-tools-version:6.1
import PackageDescription

var defaultSwiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableExperimentalFeature("Lifetimes"),
    .enableExperimentalFeature(
        "AvailabilityMacro=MediaModule 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
    ),
]

#if compiler(>=6.2)
defaultSwiftSettings.append(
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
    name: "app-media-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "MediaDomain", targets: ["MediaDomain"]),
        .library(name: "MediaApplication", targets: ["MediaApplication"]),
        .library(name: "MediaInfrastructure", targets: ["MediaInfrastructure"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-beta.5"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-storage",
            exact: "1.0.0-beta.2"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-storage-fs",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/swiftlang/swift-subprocess.git",
            .upToNextMinor(from: "0.4.0")
        ),
        .package(path: "../app-kernel"),

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
            name: "MediaDomain",
            dependencies: [
                .product(name: "Domain", package: "app-kernel")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "MediaApplication",
            dependencies: [
                .product(name: "Application", package: "app-kernel"),
                .target(name: "MediaDomain"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "MediaInfrastructure",
            dependencies: [
                .product(name: "Infrastructure", package: "app-kernel"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "FeatherStorage", package: "feather-storage"),
                .product(
                    name: "FeatherStorageFS",
                    package: "feather-storage-fs"
                ),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .target(name: "MediaApplication"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "MediaDomainTests",
            dependencies: [
                .target(name: "MediaDomain")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "MediaApplicationTests",
            dependencies: [
                .target(name: "MediaApplication")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "MediaInfrastructureTests",
            dependencies: [
                .target(name: "MediaInfrastructure"),
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
