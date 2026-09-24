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
            from: "1.12.1"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.27.0"
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
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsletterDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "NewsletterContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsletterApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),

                .target(name: "NewsletterDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsletterInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),

                .target(name: "NewsletterApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .target(
            name: "NewsletterAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsletterAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: swiftSettings
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
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "NewsletterAppOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),

                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
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
            swiftSettings: swiftSettings
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
            swiftSettings: swiftSettings
        ),
        // MARK: -
        .testTarget(
            name: "NewsletterDomainTests",
            dependencies: [
                .target(name: "NewsletterDomain"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "NewsletterApplicationTests",
            dependencies: [
                .target(name: "NewsletterApplication"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "NewsletterInfrastructureTests",
            dependencies: [
                .target(name: "NewsletterInfrastructure"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
