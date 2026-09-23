// swift-tools-version:6.3
import PackageDescription

var swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .strictMemorySafety(),
    .treatAllWarnings(as: .error),
    .enableUpcomingFeature("ExistentialAny"),
    // .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .enableUpcomingFeature("LifetimeDependence"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    .enableExperimentalFeature("LifetimeDependence"),
    .enableExperimentalFeature("Lifetimes"),
    .enableExperimentalFeature("StrictConcurrency=complete"),
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
        .library(name: "ContactDomain", targets: ["ContactDomain"]),
        .library(name: "ContactContracts", targets: ["ContactContracts"]),
        .library(name: "ContactApplication", targets: ["ContactApplication"]),
        .library(name: "ContactInfrastructure", targets: ["ContactInfrastructure"]),
        .library(name: "ContactAdminAPI", targets: ["ContactAdminAPI"]),
        .library(name: "ContactAppAPI", targets: ["ContactAppAPI"]),
        .library(name: "ContactBackend", targets: ["ContactBackend"]),
        .library(name: "ContactFrontend", targets: ["ContactFrontend"]),
        .executable(name: "ContactAdminOpenAPIGenerator", targets: ["ContactAdminOpenAPIGenerator"]),
        .executable(name: "ContactAppOpenAPIGenerator", targets: ["ContactAppOpenAPIGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mattpolzin/OpenAPIKit", from: "5.0.0"),
        .package(url: "https://github.com/jpsim/Yams", from: "6.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.9.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.27.0"),
        .package(url: "https://github.com/swift-server/async-http-client", from: "1.0.0"),

        .package(path: "../../feather-core"),
        .package(path: "../app-system-module"),
        .package(path: "../app-web-module"),
    ],
    targets: [
        .target(
            name: "ContactContracts",
            dependencies: [
                .product(name: "FeatherContracts", package: "feather-core")
            ],
            path: "Sources/Contracts",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "ContactContracts"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "SystemApplication", package: "app-system-module"),

                .target(name: "ContactDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),

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

                .target(name: "ContactInfrastructure"),
                .target(name: "ContactAdminAPI"),
                .target(name: "ContactAppAPI"),

            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ContactFrontend",
            dependencies: [
                .product(name: "FeatherAdmin", package: "feather-core"),
                .product(name: "SystemContracts", package: "app-system-module"),
                .product(name: "WebFrontend", package: "app-web-module"),

                .target(name: "ContactContracts"),
                .target(name: "ContactAdminAPI"),
                .target(name: "ContactAppAPI"),
            ],
            path: "Sources/Composition/Frontend",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "ContactDomainTests",
            dependencies: [
                .target(name: "ContactDomain"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "ContactApplicationTests",
            dependencies: [
                .target(name: "ContactApplication"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "ContactInfrastructureTests",
            dependencies: [
                .target(name: "ContactInfrastructure"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
