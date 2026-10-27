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
        .library(name: "FeatherModuleKit", targets: ["FeatherModuleKit"]),
        .library(name: "FeatherTesting", targets: ["FeatherTesting"]),
        .library(
            name: "FeatherInfrastructure",
            targets: ["FeatherInfrastructure"]
        ),
        .library(name: "FeatherBackend", targets: ["FeatherBackend"]),
        .library(
            name: "FeatherOpenAPIGenerator",
            targets: ["FeatherOpenAPIGenerator"]
        ),
        .library(name: "FeatherWebApp", targets: ["FeatherWebApp"]),
        .library(name: "FeatherWebAdmin", targets: ["FeatherWebAdmin"]),
        .library(name: "FeatherWebShared", targets: ["FeatherWebShared"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-server/swift-service-lifecycle",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-jobs",
            from: "1.1.0"
        ),
        .package(
            url: "https://github.com/BinaryBirds/swift-nanoid",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-storage",
            exact: "1.0.0-rc.3"
        ),
        .package(
            url: "https://github.com/swiftlang/swift-subprocess",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/binarybirds/swift-bcrypt",
            from: "2.0.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.3"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-dbal",
            exact: "1.0.0-alpha.1"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-sql",
            exact: "1.0.0-alpha.1"
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
            url: "https://github.com/apple/swift-configuration",
            from: "1.0.2"
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
            url: "https://github.com/feather-framework/feather-mail",
            exact: "1.0.0-rc.3"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-openapi",
            exact: "1.0.0-rc.2"
        ),
        .package(
            url: "https://github.com/mattpolzin/OpenAPIKit",
            from: "7.0.0"
        ),
        .package(
            url:
                "https://github.com/swift-server/swift-openapi-async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/swift-server/async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-openapi-runtime",
            from: "1.13.2"
        ),
        .package(
            url: "https://github.com/apple/swift-http-types",
            from: "1.7.0"
        ),
        .package(
            url: "https://github.com/apple/swift-nio",
            from: "2.0.0"
        ),
    ],
    targets: [
        .target(
            name: "FeatherModuleKit",
            dependencies: [

            ],
            path: "Sources/ModuleKit",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherTesting",
            dependencies: [
                .target(name: "FeatherModuleKit"),
                .target(name: "FeatherApplication"),
                .target(name: "FeatherDomain"),
                .product(name: "FeatherDatabase", package: "feather-database"),
            ],
            path: "Sources/Testing",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherDomain",
            dependencies: [
                .target(name: "FeatherModuleKit"),
                .product(name: "FeatherStorage", package: "feather-storage"),
            ],
            path: "Sources/Layers/Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherApplication",
            dependencies: [
                .target(name: "FeatherDomain"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherStorage", package: "feather-storage"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherInfrastructure",
            dependencies: [
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "FeatherDBAL", package: "feather-dbal"),
                .product(name: "FeatherSQL", package: "feather-sql"),
                .product(name: "FeatherStorage", package: "feather-storage"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "Jobs", package: "swift-jobs"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(
                    name: "ServiceLifecycle",
                    package: "swift-service-lifecycle"
                ),
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
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),

                .target(name: "FeatherModuleKit"),
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
            name: "FeatherWebShared",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .target(name: "FeatherModuleKit"),
            ],
            path: "Sources/Composition/WebShared",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherWebApp",
            dependencies: [
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "WebBuilders", package: "swift-web-standards"),
                .product(name: "WebComponents", package: "swift-web-standards"),
                .target(name: "FeatherModuleKit"),
                .target(name: "FeatherWebShared"),
            ],
            path: "Sources/Composition/WebApp",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherWebAdmin",
            dependencies: [
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdAuth", package: "hummingbird-auth"),
                .product(name: "CSS", package: "swift-web-standards"),
                .product(name: "DOM", package: "swift-web-standards"),
                .product(name: "HTML", package: "swift-web-standards"),
                .product(name: "SGML", package: "swift-web-standards"),
                .product(name: "SVG", package: "swift-web-standards"),
                .product(name: "WebComponents", package: "swift-web-standards"),
                .product(
                    name: "FeatherValidation",
                    package: "feather-validation"
                ),
                .product(
                    name: "FeatherValidationFoundation",
                    package: "feather-validation"
                ),
                .product(
                    name: "OpenAPIAsyncHTTPClient",
                    package: "swift-openapi-async-http-client"
                ),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIOCore", package: "swift-nio"),

                .target(name: "FeatherWebShared"),
                .target(name: "FeatherApplication"),
            ],
            path: "Sources/Composition/WebAdmin",
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
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "FeatherSQL", package: "feather-sql"),
                .target(name: "FeatherModuleKit"),
                .target(name: "FeatherDomain"),
                .target(name: "FeatherInfrastructure"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "BackendTests",
            dependencies: [
                .target(name: "FeatherBackend")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AdminTests",
            dependencies: [
                .target(name: "FeatherWebAdmin"),
                .product(name: "Hummingbird", package: "hummingbird"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
