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
        "AvailabilityMacro=FeatherCore 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
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
            url: "https://github.com/swift-server/swift-service-lifecycle.git",
            from: "2.0.0"
        ),
        //        .package(
        //            url: "https://github.com/apple/swift-log",
        //            from: "1.0.0"
        //        ),
        //        .package(
        //            url: "https://github.com/BinaryBirds/swift-nanoid",
        //            from: "1.0.0"
        //        ),
        //        .package(
        //            url: "https://github.com/binarybirds/swift-bcrypt",
        //            from: "2.0.1"
        //        ),
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-rc.2"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.20.1"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird-auth",
            from: "2.0.0"
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
            url: "https://github.com/swift-server/async-http-client.git",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-openapi-runtime",
            from: "1.9.0"
        ),
        .package(
            url: "https://github.com/apple/swift-nio.git",
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
            name: "FeatherDomain",
            dependencies: [

            ],
            path: "Sources/Layers/Domain",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "FeatherApplication",
            dependencies: [
                .target(name: "FeatherDomain"),
                .target(name: "FeatherContracts")
                //                .target(name: "FeatherError"),
                //                .product(name: "FeatherValidation", package: "feather-validation"),
            ],
            path: "Sources/Layers/Application",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "FeatherContracts",
            dependencies: [],
            path: "Sources/Contracts",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "FeatherInfrastructure",
            dependencies: [
                .target(name: "FeatherApplication"),
                .target(name: "FeatherContracts"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(
                    name: "ServiceLifecycle",
                    package: "swift-service-lifecycle"
                ),
            ],
            path: "Sources/Layers/Infrastructure",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "FeatherBackend",
            dependencies: [
                .target(name: "FeatherApplication"),
                .target(name: "FeatherContracts"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                )
            ],
            path: "Sources/Composition/Backend",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "FeatherOpenAPIGenerator",
            dependencies: [
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "OpenAPIKit", package: "OpenAPIKit")
            ],
            path: "Sources/OpenAPIGenerator",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "FeatherAdmin",
            dependencies: [
                .target(name: "FeatherApplication"),
                .target(name: "FeatherContracts"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdAuth", package: "hummingbird-auth"),
                .product(name: "WebStandards", package: "swift-web-standards"),
                .product(name: "FeatherValidation", package: "feather-validation"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIOCore", package: "swift-nio")
            ],
            path: "Sources/Composition/Frontend/Admin",
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: [
                .target(name: "FeatherDomain")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "ApplicationTests",
            dependencies: [
                .target(name: "FeatherApplication")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "InfrastructureTests",
            dependencies: [
                .target(name: "FeatherInfrastructure")
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
