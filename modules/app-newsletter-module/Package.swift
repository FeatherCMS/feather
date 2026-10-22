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
        .library(name: "NewsletterModule", targets: ["NewsletterModule"]),
        .library(name: "NewsletterApplication", targets: ["NewsletterApplication"]),
        .library(name: "NewsletterInfrastructure", targets: ["NewsletterInfrastructure"]),
        .library(name: "NewsletterAdminAPI", targets: ["NewsletterAdminAPI"]),
        .library(name: "NewsletterAppAPI", targets: ["NewsletterAppAPI"]),
        .library(name: "NewsletterBackend", targets: ["NewsletterBackend"]),
        .library(name: "NewsletterWebAdmin", targets: ["NewsletterWebAdmin"]),
        .library(name: "NewsletterWebApp", targets: ["NewsletterWebApp"]),
        .executable(name: "NewsletterAdminOpenAPIGenerator", targets: ["NewsletterAdminOpenAPIGenerator"]),
        .executable(name: "NewsletterAppOpenAPIGenerator", targets: ["NewsletterAppOpenAPIGenerator"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/mattpolzin/OpenAPIKit",
            from: "7.0.0"
        ),
        .package(
            url: "https://github.com/jpsim/Yams",
            from: "6.2.0"
        ),
        .package(
            url: "https://github.com/apple/swift-openapi-runtime",
            from: "1.13.2"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.27.0"
        ),
        .package(
            url: "https://github.com/swift-server/async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-jobs",
            from: "1.1.0"
        ),

        .package(path: "../../feather-core"),
        .package(
            url: "https://github.com/feather-framework/feather-dbal",
            exact: "1.0.0-alpha.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-dbal-postgres",
            exact: "1.0.0-alpha.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-mail",
            exact: "1.0.0-rc.1"
        ),
        .package(path: "../app-system-module"),
        .package(path: "../app-web-module"),
    ],
    targets: [
        .target(
            name: "NewsletterModule",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core")
            ],
            path: "Sources/Module",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsletterDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "NewsletterModule"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsletterApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),

                .target(name: "NewsletterDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsletterInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "FeatherDBALPostgres", package: "feather-dbal-postgres"),
                .product(name: "Jobs", package: "swift-jobs"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),

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
                .product(name: "SystemModule", package: "app-system-module"),

                .target(name: "NewsletterInfrastructure"),
                .target(name: "NewsletterAdminAPI"),
                .target(name: "NewsletterAppAPI"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsletterWebAdmin",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),

                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),
                .product(name: "WebModuleWebApp", package: "app-web-module"),
                .product(name: "WebModuleWebAdmin", package: "app-web-module"),
                .target(name: "NewsletterModule"),
                .target(name: "NewsletterAdminAPI"),
            ],
            path: "Sources/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "NewsletterWebApp",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "WebModuleWebApp", package: "app-web-module"),
                .target(name: "NewsletterModule"),
                .target(name: "NewsletterAppAPI"),
            ],
            path: "Sources/Composition/WebApp",
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
