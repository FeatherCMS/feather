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
        "AvailabilityMacro=BlogBackend 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
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
    name: "app-blog-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "BlogDomain", targets: ["BlogDomain"]),
        .library(name: "BlogContracts", targets: ["BlogContracts"]),
        .library(name: "BlogApplication", targets: ["BlogApplication"]),
        .library(name: "BlogInfrastructure", targets: ["BlogInfrastructure"]),
        .library(name: "BlogAdminAPI", targets: ["BlogAdminAPI"]),
        .library(name: "BlogAppAPI", targets: ["BlogAppAPI"]),
        .library(
            name: "BlogSharedOpenAPIGenerator",
            targets: ["BlogSharedOpenAPIGenerator"]
        ),
        .executable(
            name: "BlogAdminOpenAPIGenerator",
            targets: ["BlogAdminOpenAPIGenerator"]
        ),
        .executable(
            name: "BlogAppOpenAPIGenerator",
            targets: ["BlogAppOpenAPIGenerator"]
        ),
        .library(name: "BlogBackend", targets: ["BlogBackend"]),
        .library(
            name: "BlogFrontend",
            targets: ["BlogFrontend"]
        ),
    ],
    dependencies: [
        // [docc-plugin-placeholder]
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.0.0"
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
            url: "https://github.com/apple/swift-nio",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-nio-ssl.git",
            from: "2.34.0"
        ),
        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
        .package(path: "../app-web-module"),
        .package(path: "../app-media-module"),

    ],
    targets: [
        .target(
            name: "BlogContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "BlogDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherContracts", package: "feather-core"),
                .product(name: "WebDomain", package: "app-web-module")
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "BlogApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(
                    name: "SystemDomain",
                    package: "app-system-module"
                ),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),
                .target(name: "BlogDomain"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "BlogContracts"),

            ],
            path: "Sources/Layers/Application",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "BlogInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(
                    name: "SystemApplication",
                    package: "app-system-module"
                ),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .target(name: "BlogApplication"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "BlogContracts"),

            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .target(
            name: "BlogAdminAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "BlogContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "WebApplication", package: "app-web-module")],
            path: "Sources/APIs/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "BlogAppAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "BlogContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "WebApplication", package: "app-web-module")],
            path: "Sources/APIs/App",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .target(
            name: "BlogSharedOpenAPIGenerator",
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
        .executableTarget(
            name: "BlogAdminOpenAPIGenerator",
            dependencies: [
                .target(name: "BlogSharedOpenAPIGenerator"),
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
            name: "BlogAppOpenAPIGenerator",
            dependencies: [
                .target(name: "BlogSharedOpenAPIGenerator"),
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
        // MARK: -
        .target(
            name: "BlogBackend",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebAdminAPI", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),
                .product(name: "WebInfrastructure", package: "app-web-module"),
                .product(
                    name: "SystemInfrastructure",
                    package: "app-system-module"
                ),
                .product(name: "MediaBackend", package: "app-media-module"),
                .target(name: "BlogApplication"),
                .target(name: "BlogInfrastructure"),
                .target(name: "BlogAdminAPI"),
                .target(name: "BlogAppAPI"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "BlogContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "BlogFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "WebApplication", package: "app-web-module"),
                .product(name: "WebDomain", package: "app-web-module"),
                .product(name: "WebFrontend", package: "app-web-module"),
                .product(name: "WebAdminAPI", package: "app-web-module"),
                .product(name: "MediaFrontend", package: "app-media-module"),
                .target(name: "BlogAdminAPI"),
                .target(name: "BlogAppAPI"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "WebStandards", package: "swift-web-standards"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "FeatherValidation", package: "feather-validation"),
                .product(name: "FeatherValidationFoundation", package: "feather-validation"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIOCore", package: "swift-nio"),
            
                .product(name: "FeatherContracts", package: "feather-core"),
                .target(name: "BlogContracts"),
                .product(name: "SystemApplication", package: "app-system-module"),
            ],
            path: "Sources/Composition/Frontend",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .testTarget(
            name: "BlogDomainTests",
            dependencies: [
                .target(name: "BlogDomain")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "BlogApplicationTests",
            dependencies: [
                .target(name: "BlogApplication")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "BlogInfrastructureTests",
            dependencies: [
                .target(name: "BlogInfrastructure")
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
