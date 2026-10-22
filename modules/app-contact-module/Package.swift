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
    name: "app-contact-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "ContactModule", targets: ["ContactModule"]),
        .library(name: "ContactDomain", targets: ["ContactDomain"]),
        .library(name: "ContactContracts", targets: ["ContactContracts"]),
        .library(name: "ContactApplication", targets: ["ContactApplication"]),
        .library(name: "ContactInfrastructure", targets: ["ContactInfrastructure"]),
        .library(name: "ContactAdminAPI", targets: ["ContactAdminAPI"]),
        .library(name: "ContactAppAPI", targets: ["ContactAppAPI"]),
        .library(name: "ContactBackend", targets: ["ContactBackend"]),
        .library(name: "ContactFrontend", targets: ["ContactFrontend"]),
        .library(name: "ContactWebShared", targets: ["ContactWebShared"]),
        .library(name: "ContactWebApp", targets: ["ContactWebApp"]),
        .library(name: "ContactWebAdmin", targets: ["ContactWebAdmin"]),
        .executable(name: "ContactAdminOpenAPIGenerator", targets: ["ContactAdminOpenAPIGenerator"]),
        .executable(name: "ContactAppOpenAPIGenerator", targets: ["ContactAppOpenAPIGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mattpolzin/OpenAPIKit", from: "7.0.0"),
        .package(url: "https://github.com/jpsim/Yams", from: "6.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.13.2"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.27.0"),
        .package(url: "https://github.com/swift-server/async-http-client", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/swift-openapi-async-http-client", from: "1.0.0"),
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
            name: "ContactModule",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core")
            ],
            path: "Sources/Module",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactContracts",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .target(name: "ContactModule"),
            ],
            path: "Sources/Contracts",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "ContactModule"),
                .target(name: "ContactContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),

                .target(name: "ContactModule"),
                .target(name: "ContactDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "FeatherDBALPostgres", package: "feather-dbal-postgres"),

                .target(name: "ContactModule"),
                .target(name: "ContactApplication"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "ContactAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "ContactAppOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),

                .target(name: "ContactModule"),
                .target(name: "ContactInfrastructure"),
                .target(name: "ContactAdminAPI"),
                .target(name: "ContactAppAPI"),

            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactWebShared",
            dependencies: [],
            path: "Sources/Composition/WebShared",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactWebApp",
            dependencies: [
                .product(name: "FeatherWebApp", package: "feather-core"),
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),
                .product(name: "WebModuleWebApp", package: "app-web-module"),
                .product(name: "WebModuleWebAdmin", package: "app-web-module"),

                .target(name: "ContactModule"),
                .target(name: "ContactContracts"),
                .target(name: "ContactAppAPI"),
                .target(name: "ContactWebShared"),
            ],
            path: "Sources/Composition/WebApp",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactWebAdmin",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),
                .product(name: "WebModuleWebApp", package: "app-web-module"),
                .product(name: "WebModuleWebAdmin", package: "app-web-module"),

                .target(name: "ContactModule"),
                .target(name: "ContactContracts"),
                .target(name: "ContactAdminAPI"),
                .target(name: "ContactWebShared"),
            ],
            path: "Sources/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactFrontend",
            dependencies: [
                .target(name: "ContactWebApp"),
                .target(name: "ContactWebAdmin"),
                .target(name: "ContactWebShared"),
            ],
            path: "Sources/Composition/Frontend",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "ContactDomainTests",
            dependencies: [
                .target(name: "ContactModule"),
                .target(name: "ContactDomain"),
            ],
            path: "Tests/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "ContactApplicationTests",
            dependencies: [
                .target(name: "ContactApplication"),
            ],
            path: "Tests/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "ContactInfrastructureTests",
            dependencies: [
                .target(name: "ContactInfrastructure"),
            ],
            path: "Tests/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
    ]
)
