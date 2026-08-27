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
    name: "app-newsletter-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "NewsletterDomain", targets: ["NewsletterDomain"]),
        .library(name: "NewsletterContracts", targets: ["NewsletterContracts"]),
        .library(name: "NewsletterApplication", targets: ["NewsletterApplication"]),
        .library(name: "NewsletterInfrastructure", targets: ["NewsletterInfrastructure"]),
        .library(name: "NewsletterAdminAPI", targets: ["NewsletterAdminAPI"]),
        .library(name: "NewsletterAppAPI", targets: ["NewsletterAppAPI"]),
        .library(name: "NewsletterBackend", targets: ["NewsletterBackend"]),
        .library(name: "NewsletterFrontend", targets: ["NewsletterFrontend"]),
        .executable(name: "NewsletterAdminOpenAPIGenerator", targets: ["NewsletterAdminOpenAPIGenerator"]),
        .executable(name: "NewsletterAppOpenAPIGenerator", targets: ["NewsletterAppOpenAPIGenerator"]),
    ],
    dependencies: [
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
            url: "https://github.com/swift-server/async-http-client",
            from: "1.0.0"
        ),

        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
        .package(path: "../app-web-module"),
    ],
    targets: [
        .target(
            name: "NewsletterContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "NewsletterDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),
                
                .target(name: "NewsletterContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "NewsletterApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),

                .target(name: "NewsletterDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "NewsletterInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),

                .target(name: "NewsletterApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .target(
            name: "NewsletterAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "NewsletterAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .executableTarget(
            name: "NewsletterAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),

                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "NewsletterAppOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),

                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .target(
            name: "NewsletterBackend",
            dependencies: [                
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),

                .target(name: "NewsletterInfrastructure"),
                .target(name: "NewsletterAdminAPI"),
                .target(name: "NewsletterAppAPI"),    
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "NewsletterFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),

                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "WebFrontend", package: "app-web-module"),
                .target(name: "NewsletterContracts"),
                .target(name: "NewsletterAdminAPI"),
                .target(name: "NewsletterAppAPI"),
            ],
            path: "Sources/Composition/Frontend",
            swiftSettings: defaultSwiftSettings
        ),
        // MARK: -
        .testTarget(
            name: "NewsletterDomainTests",
            dependencies: [
                .target(name: "NewsletterDomain"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "NewsletterApplicationTests",
            dependencies: [
                .target(name: "NewsletterApplication"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "NewsletterInfrastructureTests",
            dependencies: [
                .target(name: "NewsletterInfrastructure"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
