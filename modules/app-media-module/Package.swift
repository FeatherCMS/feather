// swift-tools-version:6.3
import PackageDescription

let sharedSwiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .strictMemorySafety(),
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

let swiftSettings = sharedSwiftSettings + [
    .treatAllWarnings(as: .error)
]

let generatedAPISwiftSettings = swiftSettings


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
        .library(name: "MediaModule", targets: ["MediaModule"]),
        .library(name: "MediaApplication", targets: ["MediaApplication"]),
        .library(name: "MediaInfrastructure", targets: ["MediaInfrastructure"]),
        .library(name: "MediaAdminAPI", targets: ["MediaAdminAPI"]),
        .library(name: "MediaAppAPI", targets: ["MediaAppAPI"]),
        .executable(name: "MediaAdminOpenAPIGenerator", targets: ["MediaAdminOpenAPIGenerator"]),
        .executable(name: "MediaAppOpenAPIGenerator", targets: ["MediaAppOpenAPIGenerator"]),
        .library(name: "MediaBackend", targets: ["MediaBackend"]),
        .library(name: "MediaWebAdmin", targets: ["MediaWebAdmin"]),
    ],
    dependencies: [

        .package(
            url: "https://github.com/feather-framework/feather-storage",
            exact: "1.0.0-rc.3"
        ),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.34.0"),
        .package(url: "https://github.com/mattpolzin/OpenAPIKit", from: "7.0.0"),
        .package(url: "https://github.com/jpsim/Yams", from: "6.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.13.2"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.27.0"),
        .package(url: "https://github.com/swift-server/async-http-client", from: "1.0.0"),
        .package(url: "https://github.com/hummingbird-project/swift-jobs", from: "1.1.0"),
        .package(
            url: "https://github.com/BinaryBirds/swift-web-standards",
            exact: "1.0.0-beta.4"
        ),
        .package(path: "../../feather-core"),
        .package(
            url: "https://github.com/feather-framework/feather-dbal",
            exact: "1.0.0-alpha.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.3"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-http-hummingbird-testing",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-http",
            exact: "1.0.0-beta.1"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-openapi-hummingbird",
            from: "2.0.1"
        ),
        .package(
            url: "https://github.com/apple/swift-http-types",
            from: "1.0.0"
        ),
        .package(path: "../app-system-module"),
    ],
    targets: [
        .target(
            name: "MediaModule",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core"),
            ],
            path: "Sources/Module",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaDomain",
            dependencies: [
                .product(name: "FeatherDomain", package: "feather-core"),

                .target(name: "MediaModule"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaApplication",
            dependencies: [
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherStorage", package: "feather-storage"),
                .product(name: "MIME", package: "swift-web-standards"),
                .product(name: "NIOCore", package: "swift-nio"),

                .target(name: "MediaDomain"),
                .target(name: "MediaModule"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaInfrastructure",
            dependencies: [
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "Jobs", package: "swift-jobs"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "SystemDomain", package: "app-system-module"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),

                .product(name: "FeatherStorage", package: "feather-storage"),
                .target(name: "MediaApplication"),
                .target(name: "MediaModule"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaAdminAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/Admin",
            swiftSettings: generatedAPISwiftSettings
        ),
        .target(
            name: "MediaAppAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            path: "Sources/APIs/App",
            swiftSettings: generatedAPISwiftSettings
        ),
        .executableTarget(
            name: "MediaAdminOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),

                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/Admin",
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "MediaAppOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPIGenerator", package: "feather-core"),

                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Generators/App",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaBackend",
            dependencies: [
                .product(name: "FeatherBackend", package: "feather-core"),
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "SystemDomain", package: "app-system-module"),
                .product(name: "SystemApplication", package: "app-system-module"),
                .product(name: "SystemModule", package: "app-system-module"),

                .target(name: "MediaApplication"),
                .target(name: "MediaInfrastructure"),
                .target(name: "MediaAdminAPI"),
                .target(name: "MediaAppAPI"),
                .target(name: "MediaModule"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "MediaWebAdmin",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .product(name: "WebBuilders", package: "swift-web-standards"),
                .product(name: "WebComponents", package: "swift-web-standards"),
                .product(name: "SystemModule", package: "app-system-module"),
                .product(name: "SystemWebAdmin", package: "app-system-module"),

                .target(name: "MediaModule"),
                .target(name: "MediaAdminAPI"),
            ],
            path: "Sources/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "MediaDomainTests",
            dependencies: [
                .target(name: "MediaDomain"),
            ],
            path: "Tests/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "MediaApplicationTests",
            dependencies: [
                .target(name: "MediaApplication"),
                .target(name: "MediaDomain"),
                .product(name: "FeatherTesting", package: "feather-core"),
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherDomain", package: "feather-core"),
            ],
            path: "Tests/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "MediaInfrastructureTests",
            dependencies: [
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(
                    name: "FeatherDatabaseTesting",
                    package: "feather-database"
                ),
                .target(name: "MediaInfrastructure"),
            ],
            path: "Tests/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "MediaBackendTests",
            dependencies: [
                .product(name: "FeatherDBALTesting", package: "feather-dbal"),
                .product(name: "FeatherApplication", package: "feather-core"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "FeatherDatabaseTesting", package: "feather-database"),
                .product(name: "FeatherDomain", package: "feather-core"),
                .product(name: "FeatherHTTP", package: "feather-http"),
                .product(
                    name: "FeatherHTTPHummingbirdTesting",
                    package: "feather-http-hummingbird-testing"
                ),
                .product(name: "FeatherInfrastructure", package: "feather-core"),
                .product(name: "FeatherModuleKit", package: "feather-core"),
                .product(name: "FeatherStorage", package: "feather-storage"),
                .product(name: "FeatherTesting", package: "feather-core"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(
                    name: "OpenAPIHummingbird",
                    package: "swift-openapi-hummingbird"
                ),
                .target(name: "MediaAdminAPI"),
                .target(name: "MediaApplication"),
                .target(name: "MediaBackend"),
                .target(name: "MediaModule"),
            ],
            path: "Tests/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "MediaWebAdminTests",
            dependencies: [
                .product(name: "FeatherWebAdmin", package: "feather-core"),
                .product(name: "FeatherWebShared", package: "feather-core"),
                .target(name: "MediaWebAdmin"),
            ],
            path: "Tests/Composition/WebAdmin",
            swiftSettings: swiftSettings
        ),
    ]
)
