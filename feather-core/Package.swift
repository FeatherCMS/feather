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
    name: "feather-core",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "FeatherDomain", targets: ["FeatherDomain"]),
        .library(name: "FeatherApplication", targets: ["FeatherApplication"]),
        .library(name: "FeatherContracts", targets: ["FeatherContracts"]),
        .library(name: "FeatherInfrastructure", targets: ["FeatherInfrastructure"]),
        .library(name: "FeatherBackend", targets: ["FeatherBackend"]),
        .library(
            name: "FeatherOpenAPIGenerator",
            targets: ["FeatherOpenAPIGenerator"]
        ),
        .library(name: "FeatherAdmin", targets: ["FeatherAdmin"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]
        //        .package(
        //            url: "https://github.com/apple/swift-configuration",
        //            exact: "1.0.2",
        //            traits: [.defaults, "CommandLineArguments"]
        //        ),
        //        .package(
        //            url: "https://github.com/apple/swift-nio",
        //            from: "2.0.0"
        //        ),
        .package(
            url: "https://github.com/swift-server/swift-service-lifecycle",
            from: "2.0.0"
        ),
        //        .package(
        //            url: "https://github.com/apple/swift-log",
        //            from: "1.0.0"
        //        ),
        .package(
            url: "https://github.com/BinaryBirds/swift-nanoid",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/binarybirds/swift-bcrypt",
            from: "2.0.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.2"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.27.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird-auth",
            from: "2.3.0"
        ),
        .package(
            url: "https://github.com/BinaryBirds/swift-web-standards",
            exact: "1.0.0-beta.4"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-validation",
            exact: "1.0.0-beta.1"
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
            url: "https://github.com/swift-server/swift-openapi-async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/swift-server/async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-openapi-runtime",
            from: "1.9.0"
        ),
        .package(
            url: "https://github.com/apple/swift-nio",
            from: "2.0.0"
        ),
        //        .package(
        //            url: "https://github.com/feather-framework/feather-database-sqlite",
        //            exact: "1.0.0-beta.9"
        //        ),
        //        .package(
        //            url: "https://github.com/feather-framework/feather-validation",
        //            exact: "1.0.0-beta.1"
        //        ),
        //        .package(
        //            url: "https://github.com/feather-framework/feather-access-control",
        //            branch: "main"
        //        ),
        //        .package(
        //            url: "https://github.com/feather-framework/feather-mail",
        //            exact: "1.0.0-beta.3"
        //        ),
        //        .package(
        //            url: "https://github.com/feather-framework/feather-mail-ephemeral",
        //            exact: "1.0.0-beta.2"
        //        ),
    ],
    targets: [
        .target(
            name: "FeatherContracts",
            dependencies: [

            ],
            path: "Sources/Contracts",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherDomain",
            dependencies: [
                .target(name: "FeatherContracts")
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherApplication",
            dependencies: [
                .target(name: "FeatherDomain"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherInfrastructure",
            dependencies: [
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
                .product(name: "NanoID", package: "swift-nanoid"),
                .product(name: "BCrypt", package: "swift-bcrypt"),
                .product(name: "NIOPosix", package: "swift-nio"),

                .target(name: "FeatherApplication"),
                .target(name: "FeatherDomain"),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherBackend",
            dependencies: [
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),

                .target(name: "FeatherInfrastructure"),
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "OpenAPIKit", package: "OpenAPIKit"),
            ],
            path: "Sources/OpenAPIGenerator",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherAdmin",
            dependencies: [
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdAuth", package: "hummingbird-auth"),
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "DOM", package: "swift-web-standards"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "SVG", package: "swift-web-standards"),
                .product(name: "WebComponents", package: "swift-web-standards"),
                .product(name: "FeatherValidation", package: "feather-validation"),
                .product(name: "FeatherValidationFoundation", package: "feather-validation"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIOCore", package: "swift-nio"),

                .target(name: "FeatherApplication"),
            ],
            path: "Sources/Composition/Frontend/Admin",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: [
                .target(name: "FeatherDomain")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "ApplicationTests",
            dependencies: [
                .target(name: "FeatherApplication")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "InfrastructureTests",
            dependencies: [
                .target(name: "FeatherInfrastructure")
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
