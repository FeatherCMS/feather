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
        "AvailabilityMacro=MediaModule 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
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
        .library(name: "MediaContracts", targets: ["MediaContracts"]),
        .library(name: "MediaApplication", targets: ["MediaApplication"]),
        .library(name: "MediaInfrastructure", targets: ["MediaInfrastructure"]),
        .library(name: "MediaAdminAPI", targets: ["MediaAdminAPI"]),
        .executable(name: "MediaAdminOpenAPIGenerator", targets: ["MediaAdminOpenAPIGenerator"]),
        .library(name: "MediaBackend", targets: ["MediaBackend"]),
        .library(name: "MediaFrontend", targets: ["MediaFrontend"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]
        
        .package(url: "https://github.com/feather-framework/feather-storage", exact: "1.0.0-beta.2"),
        .package(url: "https://github.com/feather-framework/feather-storage-fs", exact: "1.0.0-beta.1"),
        .package(url: "https://github.com/swiftlang/swift-subprocess", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/mattpolzin/OpenAPIKit", from: "5.0.0"),
        .package(url: "https://github.com/jpsim/Yams", from: "6.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.9.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.26.0"),
        .package(url: "https://github.com/swift-server/async-http-client", from: "1.0.0"),
        .package(url: "https://github.com/feather-framework/feather-database-postgres", exact: "1.0.0-rc.2"),
        .package(url: "https://github.com/vapor/postgres-nio", from: "1.32.2"),
        .package(url: "https://github.com/apple/swift-nio-ssl", from: "2.34.0"),

        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
    ],
    targets: [
        .target(
            name: "MediaContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core"),
            ],
            path: "Sources/Contracts",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "MediaDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                
                .target(name: "MediaContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "MediaApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),    
                .product(name: "SystemApplication", package: "app-system-module"),

                .target(name: "MediaDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "MediaInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                
                .product(name: "FeatherStorage", package: "feather-storage"),
                .product(name: "FeatherStorageFS", package: "feather-storage-fs"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                
                .target(name: "MediaApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "MediaAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "MediaAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),

                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "MediaBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                
                .target(name: "MediaInfrastructure"),
                .target(name: "MediaAdminAPI"),    
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "MediaFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),
                .product(name: "SystemContracts", package: "app-system-module"),

                .target(name: "MediaContracts"),
                .target(name: "MediaAdminAPI"),    
            ],
            path: "Sources/Composition/Frontend",
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "MediaDomainTests",
            dependencies: [
                .target(name: "MediaDomain"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "MediaApplicationTests",
            dependencies: [
                .target(name: "MediaApplication"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "MediaInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDatabasePostgres", package: "feather-database-postgres"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),

                .target(name: "MediaInfrastructure"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
