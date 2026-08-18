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
        "AvailabilityMacro=NewsModule 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
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
    name: "app-news-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "NewsDomain", targets: ["NewsDomain"]),
        .library(name: "NewsContracts", targets: ["NewsContracts"]),
        .library(name: "NewsApplication", targets: ["NewsApplication"]),
        .library(name: "NewsInfrastructure", targets: ["NewsInfrastructure"]),
        .library(name: "NewsAppAPI", targets: ["NewsAppAPI"]),
        .library(name: "NewsSharedOpenAPIGenerator", targets: ["NewsSharedOpenAPIGenerator"]),
        .library(name: "NewsBackend", targets: ["NewsBackend"]),
        .library(name: "NewsFrontend", targets: ["NewsFrontend"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
        .package(
            url: "https://github.com/binarybirds/swift-nanoid",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.2"
        ),
        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
        .package(path: "../app-web-module"),
        .package(path: "../app-media-module"),
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
    ],
    targets: [
        .target(
            name: "NewsContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "NewsDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherContracts", package: "feather-core"),
                .product(name: "WebDomain", package: "app-web-module"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "NewsApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),
                .target(name: "NewsDomain"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "NewsContracts"),],
            path: "Sources/Layers/Application",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "NewsInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .target(name: "NewsApplication"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "NewsContracts"),],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .target(
            name: "NewsAppAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "NewsContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "WebApplication", package: "app-web-module")],
            path: "Sources/APIs/App",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .target(
            name: "NewsSharedOpenAPIGenerator",
            dependencies: [
                .product(
                    name: "FeatherOpenAPIGenerator",
                    package: "feather-core"
                ),
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "OpenAPIKit", package: "OpenAPIKit")
            ],
            path: "Sources/Generators/Shared",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: - 
        .target(
            name: "NewsBackend",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(name: "SystemInfrastructure", package: "app-system-module"),
                .target(name: "NewsApplication"),
                .target(name: "NewsInfrastructure"),
                .target(name: "NewsAppAPI"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "NewsContracts"),
                .product(name: "SystemApplication", package: "app-system-module")],
            path: "Sources/Composition/Backend",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "NewsFrontend",
            dependencies: [
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),
                .product(name: "FeatherAdmin", package: "feather-core"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .target(name: "NewsAppAPI"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(
                    name: "OpenAPIAsyncHTTPClient",
                    package: "swift-openapi-async-http-client"
                ),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "NIOCore", package: "swift-nio"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "NewsContracts"),
                .product(name: "SystemApplication", package: "app-system-module")],
            path: "Sources/Composition/Frontend",
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
